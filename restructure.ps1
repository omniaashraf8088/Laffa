$base = "C:\Users\omnya\Downloads\vsprojects\laffa\lib\features"
$lib = "C:\Users\omnya\Downloads\vsprojects\laffa\lib"

# ============= PHASE 1: Create directories =============
$dirs = @(
    "$base\auth\presentation\screens", "$base\auth\presentation\widgets", "$base\auth\presentation\controllers",
    "$base\chat\presentation\screens", "$base\chat\presentation\widgets", "$base\chat\data\models",
    "$base\coupons\presentation\screens", "$base\coupons\presentation\widgets", "$base\coupons\data\models",
    "$base\settings\presentation\screens", "$base\settings\presentation\widgets",
    "$base\trips\presentation\screens", "$base\trips\presentation\widgets", "$base\trips\data\models",
    "$base\wallet\presentation\screens", "$base\wallet\presentation\widgets",
    "$base\saved_places\presentation\screens",
    "$base\safety_center\presentation\screens",
    "$base\home\presentation\screens", "$base\home\presentation\controllers", "$base\home\data\models",
    "$base\onboarding\presentation\screens", "$base\onboarding\presentation\widgets", "$base\onboarding\data\models",
    "$base\splash\presentation\screens",
    "$base\booking\presentation\screens", "$base\booking\presentation\controllers", "$base\booking\data\models",
    "$base\payment\presentation\screens", "$base\payment\presentation\controllers", "$base\payment\data\models",
    "$base\rating\presentation\screens", "$base\rating\presentation\controllers", "$base\rating\data\models",
    "$base\ride\presentation\screens", "$base\ride\presentation\controllers", "$base\ride\data\models",
    "$base\trip\presentation\screens", "$base\trip\presentation\controllers", "$base\trip\data\models",
    "$base\scooter_finder\presentation\controllers", "$base\scooter_finder\presentation\widgets", "$base\scooter_finder\data\models"
)
foreach ($d in $dirs) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
Write-Host "=== Directories created ==="

# ============= PHASE 2: Move files =============
function MV($s, $d) { if (Test-Path $s) { Move-Item $s $d -Force; Write-Host "  Moved: $($s|Split-Path -Leaf)" } }

# Auth
MV "$base\auth\login_screen.dart" "$base\auth\presentation\screens\login_screen.dart"
MV "$base\auth\signup_screen.dart" "$base\auth\presentation\screens\signup_screen.dart"
MV "$base\auth\forgot_password_screen.dart" "$base\auth\presentation\screens\forgot_password_screen.dart"
MV "$base\auth\auth_form_widget.dart" "$base\auth\presentation\widgets\auth_form_widget.dart"
MV "$base\auth\auth_provider.dart" "$base\auth\presentation\controllers\auth_provider.dart"
MV "$base\auth\auth_validators.dart" "$base\auth\presentation\controllers\auth_validators.dart"
MV "$base\auth\widgets\auth_error_message.dart" "$base\auth\presentation\widgets\auth_error_message.dart"
MV "$base\auth\widgets\auth_logo.dart" "$base\auth\presentation\widgets\auth_logo.dart"
MV "$base\auth\widgets\auth_navigation_link.dart" "$base\auth\presentation\widgets\auth_navigation_link.dart"
MV "$base\auth\widgets\auth_subtitle.dart" "$base\auth\presentation\widgets\auth_subtitle.dart"
MV "$base\auth\widgets\auth_title.dart" "$base\auth\presentation\widgets\auth_title.dart"
MV "$base\auth\widgets\save_password_row.dart" "$base\auth\presentation\widgets\save_password_row.dart"
MV "$base\auth\widgets\terms_checkbox.dart" "$base\auth\presentation\widgets\terms_checkbox.dart"
# Chat
MV "$base\chat\chat_screen.dart" "$base\chat\presentation\screens\chat_screen.dart"
MV "$base\chat\widgets\chat_message_model.dart" "$base\chat\data\models\chat_message_model.dart"
MV "$base\chat\widgets\message_bubble.dart" "$base\chat\presentation\widgets\message_bubble.dart"
MV "$base\chat\widgets\chat_input_bar.dart" "$base\chat\presentation\widgets\chat_input_bar.dart"
# Coupons
MV "$base\coupons\coupons_screen.dart" "$base\coupons\presentation\screens\coupons_screen.dart"
MV "$base\coupons\widgets\coupon_model.dart" "$base\coupons\data\models\coupon_model.dart"
MV "$base\coupons\widgets\coupon_card.dart" "$base\coupons\presentation\widgets\coupon_card.dart"
MV "$base\coupons\widgets\coupon_input.dart" "$base\coupons\presentation\widgets\coupon_input.dart"
# Settings
MV "$base\settings\settings_screen.dart" "$base\settings\presentation\screens\settings_screen.dart"
MV "$base\settings\widgets\option_tile.dart" "$base\settings\presentation\widgets\option_tile.dart"
MV "$base\settings\widgets\settings_card.dart" "$base\settings\presentation\widgets\settings_card.dart"
MV "$base\settings\widgets\settings_tile.dart" "$base\settings\presentation\widgets\settings_tile.dart"
# Trips
MV "$base\trips\trips_screen.dart" "$base\trips\presentation\screens\trips_screen.dart"
MV "$base\trips\widgets\trip_model.dart" "$base\trips\data\models\trip_model.dart"
MV "$base\trips\widgets\trip_card.dart" "$base\trips\presentation\widgets\trip_card.dart"
MV "$base\trips\widgets\trips_empty_state.dart" "$base\trips\presentation\widgets\trips_empty_state.dart"
# Wallet
MV "$base\wallet\wallet_screen.dart" "$base\wallet\presentation\screens\wallet_screen.dart"
MV "$base\wallet\payment_methods_screen.dart" "$base\wallet\presentation\screens\payment_methods_screen.dart"
MV "$base\wallet\referral_screen.dart" "$base\wallet\presentation\screens\referral_screen.dart"
MV "$base\wallet\widgets\wallet_balance_card.dart" "$base\wallet\presentation\widgets\wallet_balance_card.dart"
# Saved Places
MV "$base\saved_places\saved_places_screen.dart" "$base\saved_places\presentation\screens\saved_places_screen.dart"
# Safety Center
MV "$base\safety_center\safety_center_screen.dart" "$base\safety_center\presentation\screens\safety_center_screen.dart"
# Home
MV "$base\home\home_provider.dart" "$base\home\presentation\controllers\home_provider.dart"
MV "$base\home\map_view_widget.dart" "$base\home\presentation\widgets\map_view_widget.dart"
MV "$base\home\search_bar_widget.dart" "$base\home\presentation\widgets\search_bar_widget.dart"
MV "$base\home\station_card_widget.dart" "$base\home\presentation\widgets\station_card_widget.dart"
MV "$base\home\station_marker.dart" "$base\home\presentation\widgets\station_marker.dart"
MV "$base\home\station_model.dart" "$base\home\data\models\station_model.dart"
MV "$base\home\presentation\home_screen.dart" "$base\home\presentation\screens\home_screen.dart"
# Onboarding
MV "$base\onboarding\onboarding_screen.dart" "$base\onboarding\presentation\screens\onboarding_screen.dart"
MV "$base\onboarding\onboarding_page.dart" "$base\onboarding\presentation\widgets\onboarding_page.dart"
MV "$base\onboarding\onboarding_model.dart" "$base\onboarding\data\models\onboarding_model.dart"
# Splash
MV "$base\splash\splash_screen.dart" "$base\splash\presentation\screens\splash_screen.dart"
# Booking
MV "$base\booking\presentation\booking_screen.dart" "$base\booking\presentation\screens\booking_screen.dart"
MV "$base\booking\domain\booking_provider.dart" "$base\booking\presentation\controllers\booking_provider.dart"
MV "$base\booking\domain\booking_model.dart" "$base\booking\data\models\booking_model.dart"
# Payment
MV "$base\payment\presentation\payment_screen.dart" "$base\payment\presentation\screens\payment_screen.dart"
MV "$base\payment\domain\payment_provider.dart" "$base\payment\presentation\controllers\payment_provider.dart"
MV "$base\payment\domain\payment_model.dart" "$base\payment\data\models\payment_model.dart"
# Rating
MV "$base\rating\presentation\rating_screen.dart" "$base\rating\presentation\screens\rating_screen.dart"
MV "$base\rating\domain\rating_provider.dart" "$base\rating\presentation\controllers\rating_provider.dart"
MV "$base\rating\domain\rating_model.dart" "$base\rating\data\models\rating_model.dart"
# Ride
MV "$base\ride\presentation\qr_unlock_screen.dart" "$base\ride\presentation\screens\qr_unlock_screen.dart"
MV "$base\ride\presentation\ride_tracking_screen.dart" "$base\ride\presentation\screens\ride_tracking_screen.dart"
MV "$base\ride\presentation\ride_payment_screen.dart" "$base\ride\presentation\screens\ride_payment_screen.dart"
MV "$base\ride\presentation\ride_history_screen.dart" "$base\ride\presentation\screens\ride_history_screen.dart"
MV "$base\ride\domain\ride_provider.dart" "$base\ride\presentation\controllers\ride_provider.dart"
MV "$base\ride\domain\ride_model.dart" "$base\ride\data\models\ride_model.dart"
# Trip (start/end)
MV "$base\trip\presentation\start_trip_screen.dart" "$base\trip\presentation\screens\start_trip_screen.dart"
MV "$base\trip\presentation\end_trip_screen.dart" "$base\trip\presentation\screens\end_trip_screen.dart"
MV "$base\trip\domain\trip_provider.dart" "$base\trip\presentation\controllers\trip_provider.dart"
MV "$base\trip\domain\trip_model.dart" "$base\trip\data\models\trip_model.dart"
# Scooter Finder
MV "$base\scooter_finder\domain\scooter_finder_provider.dart" "$base\scooter_finder\presentation\controllers\scooter_finder_provider.dart"
MV "$base\scooter_finder\domain\scooter_suggestion_model.dart" "$base\scooter_finder\data\models\scooter_suggestion_model.dart"
MV "$base\scooter_finder\presentation\suggestion_card_widget.dart" "$base\scooter_finder\presentation\widgets\suggestion_card_widget.dart"

Write-Host "=== Files moved ==="

# Clean up empty directories
$emptyDirs = @(
    "$base\auth\widgets", "$base\chat\widgets", "$base\coupons\widgets",
    "$base\settings\widgets", "$base\trips\widgets", "$base\wallet\widgets",
    "$base\booking\domain", "$base\payment\domain", "$base\rating\domain",
    "$base\ride\domain", "$base\trip\domain"
)
foreach ($d in $emptyDirs) {
    if ((Test-Path $d) -and ((Get-ChildItem $d -Recurse -File).Count -eq 0)) {
        Remove-Item $d -Recurse -Force
        Write-Host "  Removed empty: $($d.Replace($base,''))"
    }
}

# ============= PHASE 3: Fix imports =============
function FX($path, $reps) {
    if (-not (Test-Path $path)) { return }
    $c = [System.IO.File]::ReadAllText($path)
    $changed = $false
    foreach ($r in $reps) {
        if ($c.Contains($r[0])) { $c = $c.Replace($r[0], $r[1]); $changed = $true }
    }
    if ($changed) { [System.IO.File]::WriteAllText($path, $c); Write-Host "  Fixed: $($path|Split-Path -Leaf)" }
}

# --- App Router ---
FX "$lib\core\router\app_router.dart" @(
    , @("features/auth/login_screen.dart", "features/auth/presentation/screens/login_screen.dart")
    , @("features/auth/signup_screen.dart", "features/auth/presentation/screens/signup_screen.dart")
    , @("features/auth/forgot_password_screen.dart", "features/auth/presentation/screens/forgot_password_screen.dart")
    , @("features/splash/splash_screen.dart", "features/splash/presentation/screens/splash_screen.dart")
    , @("features/onboarding/onboarding_screen.dart", "features/onboarding/presentation/screens/onboarding_screen.dart")
    , @("features/home/presentation/home_screen.dart", "features/home/presentation/screens/home_screen.dart")
    , @("features/trips/trips_screen.dart", "features/trips/presentation/screens/trips_screen.dart")
    , @("features/coupons/coupons_screen.dart", "features/coupons/presentation/screens/coupons_screen.dart")
    , @("features/chat/chat_screen.dart", "features/chat/presentation/screens/chat_screen.dart")
    , @("features/settings/settings_screen.dart", "features/settings/presentation/screens/settings_screen.dart")
    , @("features/booking/presentation/booking_screen.dart", "features/booking/presentation/screens/booking_screen.dart")
    , @("features/payment/presentation/payment_screen.dart", "features/payment/presentation/screens/payment_screen.dart")
    , @("features/trip/presentation/start_trip_screen.dart", "features/trip/presentation/screens/start_trip_screen.dart")
    , @("features/trip/presentation/end_trip_screen.dart", "features/trip/presentation/screens/end_trip_screen.dart")
    , @("features/rating/presentation/rating_screen.dart", "features/rating/presentation/screens/rating_screen.dart")
    , @("features/ride/presentation/qr_unlock_screen.dart", "features/ride/presentation/screens/qr_unlock_screen.dart")
    , @("features/ride/presentation/ride_tracking_screen.dart", "features/ride/presentation/screens/ride_tracking_screen.dart")
    , @("features/ride/presentation/ride_payment_screen.dart", "features/ride/presentation/screens/ride_payment_screen.dart")
    , @("features/ride/presentation/ride_history_screen.dart", "features/ride/presentation/screens/ride_history_screen.dart")
    , @("features/wallet/wallet_screen.dart", "features/wallet/presentation/screens/wallet_screen.dart")
    , @("features/wallet/payment_methods_screen.dart", "features/wallet/presentation/screens/payment_methods_screen.dart")
    , @("features/wallet/referral_screen.dart", "features/wallet/presentation/screens/referral_screen.dart")
    , @("features/saved_places/saved_places_screen.dart", "features/saved_places/presentation/screens/saved_places_screen.dart")
    , @("features/safety_center/safety_center_screen.dart", "features/safety_center/presentation/screens/safety_center_screen.dart")
)

# --- Auth screens (feature root -> presentation/screens, +2 levels) ---
$authScrFix = @(
    , @("'../../core/", "'../../../../core/")
    , @("'../../shared/", "'../../../../shared/")
    , @("'auth_form_widget.dart'", "'../widgets/auth_form_widget.dart'")
    , @("'auth_validators.dart'", "'../controllers/auth_validators.dart'")
    , @("'auth_provider.dart'", "'../controllers/auth_provider.dart'")
    , @("'widgets/auth_", "'../widgets/auth_")
    , @("'widgets/save_password_row.dart'", "'../widgets/save_password_row.dart'")
    , @("'widgets/terms_checkbox.dart'", "'../widgets/terms_checkbox.dart'")
)
FX "$base\auth\presentation\screens\login_screen.dart" $authScrFix
FX "$base\auth\presentation\screens\signup_screen.dart" $authScrFix
FX "$base\auth\presentation\screens\forgot_password_screen.dart" $authScrFix

# --- Auth widgets (auth/widgets -> auth/presentation/widgets, +1 level) ---
$authWCore = @(, @("'../../../core/", "'../../../../core/"))
FX "$base\auth\presentation\widgets\auth_logo.dart" $authWCore
FX "$base\auth\presentation\widgets\auth_navigation_link.dart" $authWCore
FX "$base\auth\presentation\widgets\auth_subtitle.dart" $authWCore
FX "$base\auth\presentation\widgets\auth_title.dart" $authWCore
FX "$base\auth\presentation\widgets\save_password_row.dart" $authWCore
FX "$base\auth\presentation\widgets\terms_checkbox.dart" $authWCore
FX "$base\auth\presentation\widgets\auth_error_message.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../auth_provider.dart'", "'../controllers/auth_provider.dart'")
)
# Auth form widget (auth root -> auth/presentation/widgets, +2 levels)
FX "$base\auth\presentation\widgets\auth_form_widget.dart" @(, @("'../../core/", "'../../../../core/"))

# --- Chat screen (+2 levels) ---
FX "$base\chat\presentation\screens\chat_screen.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'widgets/chat_message_model.dart'", "'../../data/models/chat_message_model.dart'")
    , @("'widgets/message_bubble.dart'", "'../widgets/message_bubble.dart'")
    , @("'widgets/chat_input_bar.dart'", "'../widgets/chat_input_bar.dart'")
)
# Chat widgets (+1 level)
FX "$base\chat\presentation\widgets\message_bubble.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'chat_message_model.dart'", "'../../data/models/chat_message_model.dart'")
)
FX "$base\chat\presentation\widgets\chat_input_bar.dart" @(, @("'../../../core/", "'../../../../core/"))

# --- Coupons screen (+2 levels) ---
FX "$base\coupons\presentation\screens\coupons_screen.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'widgets/coupon_model.dart'", "'../../data/models/coupon_model.dart'")
    , @("'widgets/coupon_input.dart'", "'../widgets/coupon_input.dart'")
    , @("'widgets/coupon_card.dart'", "'../widgets/coupon_card.dart'")
)
FX "$base\coupons\presentation\widgets\coupon_card.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'coupon_model.dart'", "'../../data/models/coupon_model.dart'")
)
FX "$base\coupons\presentation\widgets\coupon_input.dart" @(, @("'../../../core/", "'../../../../core/"))

# --- Settings screen (+2 levels) ---
FX "$base\settings\presentation\screens\settings_screen.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'widgets/settings_card.dart'", "'../widgets/settings_card.dart'")
    , @("'widgets/option_tile.dart'", "'../widgets/option_tile.dart'")
    , @("'widgets/settings_tile.dart'", "'../widgets/settings_tile.dart'")
)
$settWCore = @(, @("'../../../core/", "'../../../../core/"))
FX "$base\settings\presentation\widgets\settings_card.dart" $settWCore
FX "$base\settings\presentation\widgets\option_tile.dart" $settWCore
FX "$base\settings\presentation\widgets\settings_tile.dart" $settWCore

# --- Trips screen (+2 levels) ---
FX "$base\trips\presentation\screens\trips_screen.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'widgets/trip_model.dart'", "'../../data/models/trip_model.dart'")
    , @("'widgets/trip_card.dart'", "'../widgets/trip_card.dart'")
    , @("'widgets/trips_empty_state.dart'", "'../widgets/trips_empty_state.dart'")
)
FX "$base\trips\presentation\widgets\trip_card.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'trip_model.dart'", "'../../data/models/trip_model.dart'")
)
FX "$base\trips\presentation\widgets\trips_empty_state.dart" @(, @("'../../../core/", "'../../../../core/"))

# --- Wallet screens (+2 levels) ---
$walletFix = @(, @("'../../core/", "'../../../../core/"))
FX "$base\wallet\presentation\screens\wallet_screen.dart" $walletFix
FX "$base\wallet\presentation\screens\payment_methods_screen.dart" $walletFix
FX "$base\wallet\presentation\screens\referral_screen.dart" $walletFix
FX "$base\wallet\presentation\widgets\wallet_balance_card.dart" @(, @("'../../../core/", "'../../../../core/"))

# --- Saved Places (+2 levels) ---
FX "$base\saved_places\presentation\screens\saved_places_screen.dart" @(, @("'../../core/", "'../../../../core/"))

# --- Safety Center (+2 levels) ---
FX "$base\safety_center\presentation\screens\safety_center_screen.dart" @(, @("'../../core/", "'../../../../core/"))

# --- Splash (+2 levels) ---
FX "$base\splash\presentation\screens\splash_screen.dart" @(, @("'../../core/", "'../../../../core/"))

# --- Onboarding screen (+2 levels) ---
FX "$base\onboarding\presentation\screens\onboarding_screen.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'onboarding_model.dart'", "'../../data/models/onboarding_model.dart'")
    , @("'onboarding_page.dart'", "'../widgets/onboarding_page.dart'")
)
FX "$base\onboarding\presentation\widgets\onboarding_page.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'onboarding_model.dart'", "'../../data/models/onboarding_model.dart'")
)

# --- Home screen (presentation/ -> presentation/screens/, +1 level) ---
FX "$base\home\presentation\screens\home_screen.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../home_provider.dart'", "'../controllers/home_provider.dart'")
    , @("'../station_model.dart'", "'../../data/models/station_model.dart'")
    , @("'widgets/home_drawer.dart'", "'../widgets/home_drawer.dart'")
    , @("'widgets/home_bottom_section.dart'", "'../widgets/home_bottom_section.dart'")
    , @("'widgets/home_top_overlay.dart'", "'../widgets/home_top_overlay.dart'")
    , @("'widgets/station_preview_chip.dart'", "'../widgets/station_preview_chip.dart'")
    , @("'widgets/results_pill.dart'", "'../widgets/results_pill.dart'")
    , @("'../map_view_widget.dart'", "'../widgets/map_view_widget.dart'")
    , @("'../station_card_widget.dart'", "'../widgets/station_card_widget.dart'")
)
# Home widgets that STAYED but reference moved files
FX "$base\home\presentation\widgets\home_bottom_section.dart" @(
    , @("'../../home_provider.dart'", "'../controllers/home_provider.dart'")
)
FX "$base\home\presentation\widgets\home_top_overlay.dart" @(
    , @("'../../home_provider.dart'", "'../controllers/home_provider.dart'")
    , @("'../../station_model.dart'", "'../../data/models/station_model.dart'")
    , @("'../../search_bar_widget.dart'", "'search_bar_widget.dart'")
)
FX "$base\home\presentation\widgets\station_preview_chip.dart" @(
    , @("'../../station_model.dart'", "'../../data/models/station_model.dart'")
)
# Home widgets that MOVED from home/ to home/presentation/widgets/ (+2 levels)
FX "$base\home\presentation\widgets\map_view_widget.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'station_model.dart'", "'../../data/models/station_model.dart'")
    , @("'home_provider.dart'", "'../controllers/home_provider.dart'")
)
FX "$base\home\presentation\widgets\search_bar_widget.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'home_provider.dart'", "'../controllers/home_provider.dart'")
)
FX "$base\home\presentation\widgets\station_card_widget.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'home_provider.dart'", "'../controllers/home_provider.dart'")
    , @("'station_model.dart'", "'../../data/models/station_model.dart'")
)
FX "$base\home\presentation\widgets\station_marker.dart" @(
    , @("'../../core/", "'../../../../core/")
    , @("'station_model.dart'", "'../../data/models/station_model.dart'")
)
# Home provider (home/ -> home/presentation/controllers/)
FX "$base\home\presentation\controllers\home_provider.dart" @(
    , @("'station_model.dart'", "'../../data/models/station_model.dart'")
)

# --- Booking ---
FX "$base\booking\presentation\screens\booking_screen.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../domain/booking_provider.dart'", "'../controllers/booking_provider.dart'")
    , @("'widgets/bike_card.dart'", "'../widgets/bike_card.dart'")
    , @("'widgets/booking_summary_widget.dart'", "'../widgets/booking_summary_widget.dart'")
    , @("'widgets/duration_picker_widget.dart'", "'../widgets/duration_picker_widget.dart'")
)
FX "$base\booking\presentation\controllers\booking_provider.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../data/booking_repository.dart'", "'../../data/booking_repository.dart'")
    , @("'../domain/booking_model.dart'", "'../../data/models/booking_model.dart'")
)
FX "$base\booking\data\booking_repository.dart" @(
    , @("'../domain/booking_model.dart'", "'models/booking_model.dart'")
)
FX "$base\booking\presentation\widgets\bike_card.dart" @(
    , @("'../../domain/booking_model.dart'", "'../../data/models/booking_model.dart'")
)
FX "$base\booking\presentation\widgets\booking_summary_widget.dart" @(
    , @("'../../domain/booking_model.dart'", "'../../data/models/booking_model.dart'")
)

# --- Payment ---
FX "$base\payment\presentation\screens\payment_screen.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../domain/payment_provider.dart'", "'../controllers/payment_provider.dart'")
    , @("'widgets/payment_form_widget.dart'", "'../widgets/payment_form_widget.dart'")
    , @("'widgets/payment_method_selector.dart'", "'../widgets/payment_method_selector.dart'")
    , @("'widgets/payment_summary_widget.dart'", "'../widgets/payment_summary_widget.dart'")
)
FX "$base\payment\presentation\controllers\payment_provider.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../data/payment_repository.dart'", "'../../data/payment_repository.dart'")
    , @("'../domain/payment_model.dart'", "'../../data/models/payment_model.dart'")
)
FX "$base\payment\data\payment_repository.dart" @(
    , @("'../domain/payment_model.dart'", "'models/payment_model.dart'")
)
FX "$base\payment\presentation\widgets\payment_method_selector.dart" @(
    , @("'../../domain/payment_model.dart'", "'../../data/models/payment_model.dart'")
)

# --- Rating ---
FX "$base\rating\presentation\screens\rating_screen.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../domain/rating_model.dart'", "'../../data/models/rating_model.dart'")
    , @("'../domain/rating_provider.dart'", "'../controllers/rating_provider.dart'")
    , @("'widgets/star_rating_widget.dart'", "'../widgets/star_rating_widget.dart'")
    , @("'widgets/feedback_tags_widget.dart'", "'../widgets/feedback_tags_widget.dart'")
    , @("'widgets/review_text_field.dart'", "'../widgets/review_text_field.dart'")
)
FX "$base\rating\presentation\controllers\rating_provider.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../data/rating_repository.dart'", "'../../data/rating_repository.dart'")
    , @("'rating_model.dart'", "'../../data/models/rating_model.dart'")
)
FX "$base\rating\data\rating_repository.dart" @(
    , @("'../domain/rating_model.dart'", "'models/rating_model.dart'")
)

# --- Ride ---
$rideScrFix = @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../domain/ride_model.dart'", "'../../data/models/ride_model.dart'")
    , @("'../domain/ride_provider.dart'", "'../controllers/ride_provider.dart'")
)
FX "$base\ride\presentation\screens\qr_unlock_screen.dart" $rideScrFix
FX "$base\ride\presentation\screens\ride_tracking_screen.dart" $rideScrFix
FX "$base\ride\presentation\screens\ride_payment_screen.dart" $rideScrFix
FX "$base\ride\presentation\screens\ride_history_screen.dart" $rideScrFix
FX "$base\ride\presentation\controllers\ride_provider.dart" @(
    , @("'ride_model.dart'", "'../../data/models/ride_model.dart'")
)

# --- Trip (start/end) ---
FX "$base\trip\presentation\screens\start_trip_screen.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../../booking/domain/booking_provider.dart'", "'../../booking/presentation/controllers/booking_provider.dart'")
    , @("'../domain/trip_model.dart'", "'../../data/models/trip_model.dart'")
    , @("'../domain/trip_provider.dart'", "'../controllers/trip_provider.dart'")
    , @("'widgets/trip_timer_widget.dart'", "'../widgets/trip_timer_widget.dart'")
    , @("'widgets/trip_info_card.dart'", "'../widgets/trip_info_card.dart'")
)
FX "$base\trip\presentation\screens\end_trip_screen.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../domain/trip_model.dart'", "'../../data/models/trip_model.dart'")
    , @("'../domain/trip_provider.dart'", "'../controllers/trip_provider.dart'")
    , @("'widgets/trip_info_card.dart'", "'../widgets/trip_info_card.dart'")
)
FX "$base\trip\presentation\controllers\trip_provider.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../data/trip_repository.dart'", "'../../data/trip_repository.dart'")
    , @("'../domain/trip_model.dart'", "'../../data/models/trip_model.dart'")
)
FX "$base\trip\data\trip_repository.dart" @(
    , @("'../domain/trip_model.dart'", "'models/trip_model.dart'")
)
# Trip widgets that may reference domain
FX "$base\trip\presentation\widgets\trip_info_card.dart" @(
    , @("'../../domain/trip_model.dart'", "'../../data/models/trip_model.dart'")
    , @("'../../domain/trip_provider.dart'", "'../controllers/trip_provider.dart'")
)
FX "$base\trip\presentation\widgets\trip_timer_widget.dart" @(
    , @("'../../domain/trip_model.dart'", "'../../data/models/trip_model.dart'")
    , @("'../../domain/trip_provider.dart'", "'../controllers/trip_provider.dart'")
)

# --- Scooter Finder ---
FX "$base\scooter_finder\presentation\widgets\suggestion_card_widget.dart" @(
    , @("'../../../core/", "'../../../../core/")
    , @("'../domain/scooter_finder_provider.dart'", "'../controllers/scooter_finder_provider.dart'")
    , @("'../domain/scooter_suggestion_model.dart'", "'../../data/models/scooter_suggestion_model.dart'")
)
FX "$base\scooter_finder\presentation\controllers\scooter_finder_provider.dart" @(
    , @("'../data/scooter_finder_repository.dart'", "'../../data/scooter_finder_repository.dart'")
    , @("'find_best_scooter_usecase.dart'", "'../../domain/find_best_scooter_usecase.dart'")
    , @("'scooter_suggestion_model.dart'", "'../../data/models/scooter_suggestion_model.dart'")
)
FX "$base\scooter_finder\domain\find_best_scooter_usecase.dart" @(
    , @("'scooter_suggestion_model.dart'", "'../data/models/scooter_suggestion_model.dart'")
)
FX "$base\scooter_finder\data\scooter_finder_repository.dart" @(
    , @("'../domain/scooter_suggestion_model.dart'", "'models/scooter_suggestion_model.dart'")
)

Write-Host "`n=== RESTRUCTURE COMPLETE ==="
