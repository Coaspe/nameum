import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/app.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          elevation: 3,
          onPressed: () {},
          backgroundColor: Colors.black,
          child: const Center(
            child: Icon(
              Icons.alarm,
              color: Colors.white,
            ),
            //     child: Text(
            //   state.user.reserveStore.length.toString(),
            //   style: const TextStyle(
            //       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            // )
          ),
        ),
      );
    });
  }
}
