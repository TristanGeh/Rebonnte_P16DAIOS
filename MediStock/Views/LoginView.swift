import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                session.signIn(email: email, password: password)
            }) {
                Text("Login")
                    .background(Color(.blue))
                    .foregroundColor(.white)
            }
            Button(action: {
                session.signUp(email: email, password: password)
            }) {
                Text("Sign Up")
                    .background(Color(.blue))
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(SessionViewModel())
    }
}
