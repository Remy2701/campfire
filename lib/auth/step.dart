enum AuthStep {
  signUp,
  logIn;

  String toText() {
    return switch (this) {
      AuthStep.signUp => "Sign up",
      AuthStep.logIn => "Log in"
    };
  }
}
