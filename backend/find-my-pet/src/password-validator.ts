// password-validator.ts

export function validatePassword(password: string): boolean {
  // Mindestlänge des Passworts: 8 Zeichen
  // Mindestens ein Großbuchstabe
  // Mindestens ein Sonderzeichen
  // Mindestens eine Zahl
  const passwordRegex = /^(?=.*[A-Z])(?=.*[!@#$%^&*()-_=+{};:'",.<>?/\\|[\]`~])(?=.*[0-9]).{8,}$/;
  return passwordRegex.test(password);
}
