function togglePasswordVisibility() {
  const passwordField = document.getElementById("password_field");
  if (passwordField.type === "password") {
    passwordField.type = "text";
  } else {
    passwordField.type = "password";
  }
}
