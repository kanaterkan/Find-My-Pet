// email-validator.ts

export function validateEmail(email: string): boolean {
  // Einfacher Regulärer Ausdruck zur Überprüfung der E-Mail-Adresse
  const emailRegex = /\S+@\S+\.\S+/;
  return emailRegex.test(email);
}
