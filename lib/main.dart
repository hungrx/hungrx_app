import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:hungrx_app/routes/app_router.dart';
import 'package:hungrx_app/domain/usecases/sign_up_usecase.dart';
import 'package:hungrx_app/data/repositories/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(
            signUpUseCase: SignUpUseCase(
              UserRepository(),
            ),
          ),
        ),
        // Add other global BLoCs here
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'hungrX',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}