import 'package:app_core/app_core.dart';
import 'package:app_core/ui/widgets/map/widgets/map_widgets.dart';
import 'package:flutter/material.dart';

// app_map_controller.dart

class AppMapController {
  AppMapController._();

  late final MapController _raw;
  late final TickerProvider _ticker;

  /// The raw flutter_map controller — use only if you need low-level access.
  MapController get raw => _raw;

  /// Instantly move with no animation (original behavior).
  void move(LatLng latLng, double zoom) {
    _raw.move(latLng, zoom);
  }

  /// Animated camera move — replaces _mapController.move().
  void animatedMove(
    LatLng dest,
    double zoom, {
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeInOut,
  }) {
    final camera = _raw.camera;

    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: dest.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: dest.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: zoom);

    final controller = AnimationController(vsync: _ticker, duration: duration);
    final animation = CurvedAnimation(parent: controller, curve: curve);

    controller.addListener(() {
      _raw.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  /// Animated zoom only, keeping current center.
  void animatedZoom(
    double zoom, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOut,
  }) {
    animatedMove(_raw.camera.center, zoom, duration: duration, curve: curve);
  }
}

class AppMap extends StatefulWidget {
  const AppMap({
    super.key,
    this.initialCenter,
    this.initialZoom = 14.0,
    this.markers = const [],
    this.currentLocation,
    this.showCurrentLocation = false,
    this.onMarkerTap,
    this.onMapTap,
    this.controller,
    this.tileUrlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    this.userAgentPackageName = 'gov.thaison.cmps',
    this.minZoom = 3.0,
    this.maxZoom = 18.0,
    this.showZoomControls = false,
    this.showAttribution = true,
    this.interactive = true,
    this.openInMapsText = '',
    this.openInMaps,
    this.onMapReady,
  });

  final LatLng? initialCenter;
  final double initialZoom;
  final List<MapMarkerModel> markers;
  final LatLng? currentLocation;
  final bool showCurrentLocation;
  final void Function(MapMarkerModel marker)? onMarkerTap;
  final void Function(TapPosition tapPos, LatLng latLng)? onMapTap;
  final MapController? controller;
  final String tileUrlTemplate;
  final String userAgentPackageName;
  final double minZoom;
  final double maxZoom;
  final bool showZoomControls;
  final bool showAttribution;
  final bool interactive;
  final String openInMapsText;
  final VoidCallback? openInMaps;
  final void Function(AppMapController controller)? onMapReady;

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> with TickerProviderStateMixin {
  bool _isLoading = true;
  final AppMapController _appMapController = AppMapController._();

  @override
  void initState() {
    super.initState();
    _appMapController._raw = widget.controller ?? MapController();
    _appMapController._ticker = this;
  }

  @override
  void dispose() {
    if (widget.controller == null) _appMapController._raw.dispose();
    super.dispose();
  }

  // Expose to parent via onMapReady
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMapReady?.call(_appMapController);
    });
  }

  LatLng get _center =>
      widget.initialCenter ??
      widget.currentLocation ??
      const LatLng(10.7769, 106.7009);

  void _onTileLoaded() {
    if (_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _appMapController._raw,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: widget.initialZoom,
            minZoom: widget.minZoom,
            maxZoom: widget.maxZoom,
            interactionOptions: InteractionOptions(
              flags: widget.interactive
                  ? InteractiveFlag.all
                  : InteractiveFlag.none,
            ),
            onTap: widget.onMapTap,
          ),
          children: [
            // ── Tile layer ──────────────────────────────────
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'gov.thaison.cmps',
              tileProvider: NetworkTileProvider(
                cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(
                  maxCacheSize: 1_000_000_000,
                ),
              ),
              tileBuilder: (context, tileWidget, tile) {
                _onTileLoaded();
                return tileWidget;
              },
              errorTileCallback: (tile, error, stackTrace) {
                if (mounted) setState(() => _isLoading = false);
              },
            ),

            // ── Custom markers ──────────────────────────────
            MarkerLayer(markers: widget.markers.map(_buildMarker).toList()),

            // ── Current location dot ────────────────────────
            if (widget.showCurrentLocation && widget.currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.currentLocation!,
                    width: 100,
                    height: 100,
                    alignment: Alignment.bottomCenter,
                    child: PinMarker(
                      model: MapMarkerModel(
                        id: 'current',
                        latLng: widget.currentLocation!,
                      ),
                    ),
                  ),
                ],
              ),

            // ── OSM attribution ─────────────────────────────
            if (widget.showAttribution)
              RichAttributionWidget(
                showFlutterMapAttribution: false,
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright'),
                    ),
                  ),
                ],
              ),

            if (widget.openInMapsText.isNotEmpty)
              Positioned(
                right: 10,
                top: 10,
                child: AppButton(
                  onTap: widget.openInMaps,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: Text(
                    widget.openInMapsText,
                    style: AppTextStyles.semiBold10(color: AppColor.white),
                  ),
                ),
              ),
          ],
        ),

        // ── Zoom controls ───────────────────────────────────
        if (widget.showZoomControls)
          Positioned(
            right: 12,
            bottom: 36,
            child: _ZoomControls(controller: _appMapController),
          ),

        // ── Loading overlay ─────────────────────────────────
        if (_isLoading) const _MapLoadingOverlay(),
      ],
    );
  }

  Marker _buildMarker(MapMarkerModel model) {
    Widget child;

    switch (model.type) {
      case MarkerType.card:
        child = GestureDetector(
          onTap: () => widget.onMarkerTap?.call(model),
          child: CardMarker(model: model),
        );
      case MarkerType.pin:
        child = GestureDetector(
          onTap: () => widget.onMarkerTap?.call(model),
          child: PinMarker(model: model),
        );
      case MarkerType.badge:
        child = GestureDetector(
          onTap: () => widget.onMarkerTap?.call(model),
          child: BadgeMarker(model: model),
        );
      default:
        child = GestureDetector(
          onTap: () => widget.onMarkerTap?.call(model),
          child: model.customWidget ?? const SizedBox.shrink(),
        );
    }

    return Marker(
      point: model.latLng,
      width: model.width,
      height: model.height,
      alignment: model.type == MarkerType.pin
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Loading overlay
// ---------------------------------------------------------------------------

class _MapLoadingOverlay extends StatelessWidget {
  const _MapLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D9E75)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đang tải...',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Đang tải bản đồ',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Zoom controls
// ---------------------------------------------------------------------------

class _ZoomControls extends StatelessWidget {
  const _ZoomControls({required this.controller});
  final AppMapController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ZoomBtn(
          icon: Icons.add,
          onTap: () => controller.animatedZoom(
            (controller.raw.camera.zoom + 1).clamp(1, 18),
          ),
        ),
        const SizedBox(height: 4),
        _ZoomBtn(
          icon: Icons.remove,
          onTap: () => controller.animatedZoom(
            (controller.raw.camera.zoom - 1).clamp(1, 18),
          ),
        ),
      ],
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  const _ZoomBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
