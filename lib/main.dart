import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'bloc/my_form_bloc.dart';
import 'model/client.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (_) => MyFormBloc(),
          child: const MyForm(),
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyFormBloc, MyFormState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          showDialog<void>(
            context: context,
            builder: (_) => SuccessDialog(
              client: state.client.value,
            ),
          );
        }
        if (state.status.isInProgress) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Submitting...')),
            );
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment(0, -3 / 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClientInput(),
              ClientInputV2(),
              QrCodeScanner(),
              SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// doesn't update on `MyFormClientChanged(value)`
class ClientInput extends StatelessWidget {
  const ClientInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.client.value,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            labelText: 'Client',
            errorText: state.client.displayError != null
                ? 'Please ensure the client entered is valid'
                : null,
          ),
          keyboardType: TextInputType.name,
          onChanged: (value) {
            context.read<MyFormBloc>().add(MyFormClientChanged(value));
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

/// # Alternatives Considered [point one](https://github.com/felangel/bloc/issues/4209)
/// This resolve the problem but the cursor move at the start (try change some chars at the middle of the input).
/// TextEditingController's cursor can be handled correctly but required more info.
class ClientInputV2 extends StatelessWidget {
  const ClientInputV2({super.key});

  @override
  Widget build(BuildContext context) {
    final displayError = context.select<MyFormBloc, ClientValidationError?>(
        (bloc) => bloc.state.client.displayError);
    final controller = context.select<MyFormBloc, TextEditingController>(
        (bloc) => TextEditingController(text: bloc.state.client.value));

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: const Icon(Icons.email),
        labelText: 'Client',
        errorText: displayError != null
            ? 'Please ensure the client entered is valid'
            : null,
      ),
      keyboardType: TextInputType.name,
      onChanged: (value) {
        context.read<MyFormBloc>().add(MyFormClientChanged(value));
      },
      textInputAction: TextInputAction.done,
    );
  }
}

// Consider this widget as an element that opens the camera to read a QR code,
// and upon reading it, inserts it as a "client".
class QrCodeScanner extends StatelessWidget {
  const QrCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // "on camera result"
      onPressed: () => context
          .read<MyFormBloc>()
          .add(const MyFormClientChanged('client_from_qr')),
      child: const Text('QrScanner'),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((MyFormBloc bloc) => bloc.state.isValid);
    return ElevatedButton(
      onPressed: isValid
          ? () => context.read<MyFormBloc>().add(const MyFormFormSubmitted())
          : null,
      child: const Text('Submit'),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.client,
  });

  final String client;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Form Submitted Successfully with client: $client',
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
