//SOCIAL NETWORK AUTHS

// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
// import 'package:edesa/src/enums/login_type_enum.dart';
// import 'package:edesa/src/models/form_models/social_network_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:twitter_login/twitter_login.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// class AuthService {
//   static final AuthService _instance = AuthService._constructor();

//   factory AuthService() {
//     return _instance;
//   }

//   AuthService._constructor();

//   late GoogleSignIn? _googleSignIn;

//   init() async {
//     _googleSignIn = GoogleSignIn(
//       scopes: <String>[
//         'email',
//         'https://www.googleapis.com/auth/contacts.readonly',
//       ],
//     );
//   }

//   loginWithFacebook() async {
//     SocialNetworkModel? socialModel;
//     final plugin = FacebookLogin(debug: false);

//     FacebookLoginResult result = await plugin.logIn(permissions: [
//       FacebookPermission.publicProfile,
//       FacebookPermission.email,
//     ]);

//     if (result.accessToken != null &&
//         result.status == FacebookLoginStatus.success) {
//       if (result.accessToken!.userId != null) {
//         final email = await plugin.getUserEmail();
//         socialModel = SocialNetworkModel(
//             userId: result.accessToken!.userId,
//             email: email,
//             loginStatus: LoginStatus.success,
//             loginType: LoginType.facebook);
//       }
//     }

//     return socialModel;
//   }

//   loginWithGoogle() async {
//     SocialNetworkModel? socialModel;
//     try {
//       GoogleSignInAccount? result = await _googleSignIn!.signIn();

//       if (result != null) {
//         socialModel = SocialNetworkModel(
//             userId: result.id,
//             loginStatus: LoginStatus.success,
//             email: result.email,
//             loginType: LoginType.google_oauth2);
//       }

//       return socialModel;
//     } catch (error) {
//       return null;
//     }
//   }

//   loginWithTwitter() async {
//     SocialNetworkModel? socialModel;
//     try {
//       final twitterLogin = TwitterLogin(
//         apiKey: "MZWCJ5hsNDe6naqorJ9zLREQn",
//         apiSecretKey: "GDdZUuioOYRdVy7lQeaZ9FPxLlWRw4W4q99nbm0RKGWzU1iHt3",
//         redirectURI: "https://edesa-bcc68.firebaseapp.com/__/auth/handler",
//       );
//       final authResult = await twitterLogin.login();

//       if (authResult.user != null && authResult.status != null) {
//         if (authResult.status == TwitterLoginStatus.loggedIn) {
//           socialModel = SocialNetworkModel(
//               userId: authResult.user!.id.toString(),
//               email: authResult.user!.email,
//               loginStatus: LoginStatus.success,
//               loginType: LoginType.twitter);
//         }
//       }

//       return socialModel;
//     } catch (error) {
//       return null;
//     }
//   }

//   loginWithMicrosoft(BuildContext context) async {
//     SocialNetworkModel? socialModel;
//     try {
//       final Config config = Config(
//         tenant: 'd89d0c3b-f57f-4f76-a7ed-74524ee95504',
//         clientId: 'c2fceb4f-47f3-4340-9f8e-1c7dae78b86f',
//         scope: 'openid profile User.Read',
//         redirectUri: 'msauth://com.mrv.edesa/LmfGmUfu%2FJeqhKgEtykyvEE5UhU%3D',
//         //redirectUri: 'https://edesa-bcc68.firebaseapp.com/__/auth/handler'
//       );

//       //Config Tobi
//       // final Config config = Config(
//       //   tenant: 'f8cdef31-a31e-4b4a-93e4-5f571e91255a',
//       //   clientId: '393eee9d-246c-4c4e-8962-d71d273dae61',
//       //   scope: 'openid profile offline_access',
//       //   redirectUri: 'msauth://com.mrv.edesa/2jmj7l5rSw0yVb%2FvlWAYkK%2FYBwk%3D',
//       // );
//       final AadOAuth oauth = AadOAuth(config);
//       oauth.setWebViewScreenSizeFromMedia(MediaQuery.of(context));

//       await oauth.login();
//       //     User? user = await FirebaseAuthOAuth().openSignInFlow(
//       // "microsoft.com", ["email openid"], {'tenant': 'd89d0c3b-f57f-4f76-a7ed-74524ee95504'});
//       var accessToken = await oauth.getAccessToken();
//       var idToken = await oauth.getIdToken();
//       print(accessToken);
//       //TODO: Counsultar Martin!
//       Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);
//       Map<String, dynamic> decodedIdToken = JwtDecoder.decode(idToken!);
//       var uid= decodedToken["puid"];
//       var email = decodedToken["email"];
//       if (uid != null && email != null) {
//         socialModel = SocialNetworkModel(
//               userId: uid,
//               email: email,
//               loginStatus: LoginStatus.success,
//               loginType: LoginType.microsoft_graph);
//       }

//       return socialModel;
//     } catch (error) {
//       return null;
//     }
//   }

//   loginWithApple() async{
//     SocialNetworkModel? socialModel;
//     try {
//       final result = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       if (result != null) {
//         socialModel = SocialNetworkModel(
//             userId: result.userIdentifier,
//             loginStatus: LoginStatus.success,
//             email: result.email,
//             loginType: LoginType.apple_id);
//       }

//       return socialModel;
//     } catch (error) {
//       return null;
//     }
//   }
// }

// LoginStatus casteFacebookState(FacebookLoginStatus status) {
//   switch (status) {
//     case FacebookLoginStatus.success:
//       return LoginStatus.success;
//     case FacebookLoginStatus.error:
//       return LoginStatus.error;
//     case FacebookLoginStatus.cancel:
//       return LoginStatus.cancel;
//   }
// }

// LoginStatus casteTwitterState(TwitterLoginStatus status) {
//   switch (status) {
//     case TwitterLoginStatus.loggedIn:
//       return LoginStatus.success;
//     case TwitterLoginStatus.error:
//       return LoginStatus.error;
//     case TwitterLoginStatus.cancelledByUser:
//       return LoginStatus.cancel;
//   }
// }
