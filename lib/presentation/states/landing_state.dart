part of '../../application/Providers/landing_provider.dart';

@immutable
sealed class LandingState {}

abstract class LandingActionState extends LandingState {}

final class LandingInitial extends LandingState {}

class LandingNavigateToLogin extends LandingActionState {}

class LandingNavigateToSignup extends LandingActionState {}
