// abstract class means this is a blueprint.
// You cannot create 'new Failure()', only 'new ServerFailure()' etc.
abstract class Failure {
  // Optional: You can store error messages here
  final String message;
  const Failure([this.message = "An unexpected error occurred"]);
}

// --- Specific Failures ---

// 1. Use this for API / Server errors
class ServerFailure extends Failure {
  const ServerFailure([super.message = "Server Error"]);
}

// 2. Use this for Local Storage / Cache errors (like LocalStorage failing)
class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache Error"]);
}

// 3. Use this for Network issues (No Internet)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No Internet Connection"]);
}
