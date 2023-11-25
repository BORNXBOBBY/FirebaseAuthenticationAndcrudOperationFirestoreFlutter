import 'package:google_auth_flutter/update_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_auth_flutter/update_account.dart';
import 'LoginPage.dart';
import 'Model/UserModel.dart';

class AccountBottomNav extends StatefulWidget {
  const AccountBottomNav({Key? key}) : super(key: key);

  @override
  State<AccountBottomNav> createState() => _AccountBottomNavState();
}

class _AccountBottomNavState extends State<AccountBottomNav> {

  UserModel?userDataModel;
  @override
  void initState() {
    super.initState();
    retriveData().then((value) {
      userDataModel = value;
      setState(() {

      });
    });
  }

  Future<UserModel?> retriveData() async {
    var auth = FirebaseAuth.instance.currentUser?.uid;
    var user = await FirebaseFirestore.instance.collection("users").doc(auth).get();
    var userModal = UserModel.fromJson(user.data()!);
    return userModal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child : Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(image: NetworkImage('https://media.licdn.com/dms/image/D4D03AQFo9m--m9fwmQ/profile-displayphoto-shrink_800_800/0/1680501705686?e=1689811200&v=beta&t=gDH9Za-Tz9IqY0NBE6znPshdtvx-cCMo3CrpJ6Epfvc')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("${userDataModel?.name}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text("${userDataModel?.address}"),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateAccount(imageUrl: '',),));
                            }, style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, side: BorderSide.none, shape: StadiumBorder()), child: Text('Edit Profile', style: TextStyle(color: Colors.white),)),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),

            Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.green),
                  ),
                  title: Text('Favourites',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),

                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.download, color: Colors.green),
                  ),
                  title: Text('Downloads',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.language, color: Colors.green),
                  ),
                  title: Text('Language',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.location_on, color: Colors.green),
                  ),
                  title: Text('Location',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.display_settings, color: Colors.green),
                  ),
                  title: Text('Display',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.mobile_friendly, color: Colors.green),
                  ),
                  title: Text('Feed preference',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.subscriptions, color: Colors.green),
                  ),
                  title: Text('Subscription',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.delete, color: Colors.green),
                  ),
                  title: Text('Clear Cache',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.browse_gallery, color: Colors.green),
                  ),
                  title: Text('Clear history',style: Theme.of(context).textTheme.bodyText1,),
                  trailing: SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,size: 20,)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100), color: Colors.green.withOpacity(0.1),
                      ),
                      child: const Icon(Icons.logout, color: Colors.red),
                    ),
                    title: Text('Log Out',style: Theme.of(context).textTheme.bodyText1,),
                    trailing: SizedBox(
                      width: 30,
                      height: 30,
                      child: InkWell(onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>  AlertDialog(
                            title: Row(
                              children: const [
                                Icon(Icons.logout),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Logout"),
                                ),
                              ],
                            ),

                            // icon: Icon(CupertinoIcons.delete),
                            content: const Text("Are you sure want to logout!"),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                              },
                                child: const Text(
                                  'No', style: TextStyle(color: Colors.red),),
                              ),
                              TextButton(onPressed: () {

                                FirebaseAuth.instance.signOut().then((value) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (context) => const LoginPage(),));
                                });

                                Fluttertoast.showToast(msg: 'Logout Successful',
                                    textColor: Colors.black,
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.white);
                              },
                                child: const Text(
                                  'Yes', style: TextStyle(color: Colors.red),),)
                            ],
                          ),);
                      },
                          child: Icon(Icons.arrow_forward_ios,size: 20,)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
