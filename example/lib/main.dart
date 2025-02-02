import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

void main() => runApp(MyApp());

// @TODO IMPORTANT - you need to change variable values below
// You need to add your own data from LinkedIn application
// From: https://www.linkedin.com/developers/
// Please read step 1 from this link https://developer.linkedin.com/docs/oauth2
final String redirectUrl = 'YOUR-REDIRECT-URL';
final String clientId = 'YOUR-CLIENT-ID';
final String clientSecret = 'YOUR-CLIENT-SECRET';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LinkedIn demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Profile',
                ),
                Tab(icon: Icon(Icons.text_fields), text: 'Auth code')
              ],
            ),
            title: Text('LinkedIn Authorization'),
          ),
          body: TabBarView(
            children: [
              LinkedInProfileExamplePage(),
              LinkedInAuthCodeExamplePage(),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkedInProfileExamplePage extends StatefulWidget {
  @override
  State createState() => _LinkedInProfileExamplePageState();
}

class _LinkedInProfileExamplePageState
    extends State<LinkedInProfileExamplePage> {
  UserObject user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: user == null
              ? LinkedInButtonStandardWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LinkedInUserWidget(
                    appBar: AppBar(
                      title: Text('OAuth User'),
                    ),
                    redirectUrl: redirectUrl,
                    clientId: clientId,
                    clientSecret: clientSecret,
                    onGetUserProfile:
                        (LinkedInUserModel linkedInUser) {
                      print(
                          'Access token ${linkedInUser.token.accessToken}');

                      print('User id: ${linkedInUser.userId}');

                      user = UserObject(
                        firstName:
                        linkedInUser.firstName.localized.label,
                        lastName:
                        linkedInUser.lastName.localized.label,
                        email: linkedInUser.email.elements[0]
                            .handleDeep.emailAddress,
                      );
                      setState(() {});

                      Navigator.pop(context);
                    },
                    catchError: (LinkedInErrorObject error) {
                      print('Error description: ${error.description},'
                          ' Error code: ${error.statusCode.toString()}');
                      Navigator.pop(context);
                    },
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          )
              : Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('First: ${user.firstName} '),
                Text('Last: ${user.lastName} '),
                Text('Email: ${user.email}'),
              ],
            ),
          )),
    );
  }
}

class LinkedInAuthCodeExamplePage extends StatefulWidget {
  @override
  State createState() => _LinkedInAuthCodeExamplePageState();
}

class _LinkedInAuthCodeExamplePageState
    extends State<LinkedInAuthCodeExamplePage> {
  AuthCodeObject authorizationCode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: authorizationCode == null
              ? LinkedInButtonStandardWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      LinkedInAuthCodeWidget(
                        redirectUrl: redirectUrl,
                        clientId: clientId,
                        onGetAuthCode:
                            (AuthorizationCodeResponse response) {
                          print('Auth code ${response.code}');

                          print('State: ${response.state}');

                          authorizationCode = AuthCodeObject(
                            code: response.code,
                            state: response.state,
                          );
                          setState(() {});

                          Navigator.pop(context);
                        },
                        catchError: (LinkedInErrorObject error) {
                          print('Error description: ${error.description},'
                              ' Error code: ${error.statusCode.toString()}');
                          Navigator.pop(context);
                        },
                      ),
                  fullscreenDialog: true,
                ),
              );
            },
          )
              : Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Auth code: ${authorizationCode.code} '),
                Text('State: ${authorizationCode.state} '),
              ],
            ),
          )),
    );
  }
}

class AuthCodeObject {
  String code, state;

  AuthCodeObject({this.code, this.state});
}

class UserObject {
  String firstName, lastName, email;

  UserObject({this.firstName, this.lastName, this.email});
}