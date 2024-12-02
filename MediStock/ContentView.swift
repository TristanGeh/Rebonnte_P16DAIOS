import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel

    var body: some View {
        Group {
            if sessionViewModel.session != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            sessionViewModel.listen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
