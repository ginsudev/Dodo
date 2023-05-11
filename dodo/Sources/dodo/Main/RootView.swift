import SwiftUI
import GSCore
import Comet

struct RootView: View {
    @StateObject private var preferenceStorage = PreferenceStorage()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Colors.formBackground
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 25) {
                    headerView
                    enableButton
                    sections
                    respringButton
                    Spacer()
                    CopywriteView()
                }
                .padding()
            }
        }
    }
}

private extension RootView {
    var headerView: some View {
        HeaderView(
            viewModel: .init(
                title: "Dodo",
                version: "4.0.9.1",
                author: .ginsu
            )
        )
    }
    
    var enableButton: some View {
        PreferenceCell(cell: .enabled(isEnabled: $preferenceStorage.isEnabled))
    }
    
    var sections: some View {
        DetailedNavigationLinkGroupView(links: [
            DetailedNavigationLink(cell: .appearance) {
                AnyView(
                    AppearanceView()
                        .environmentObject(preferenceStorage)
                )
            },
            DetailedNavigationLink(cell: .behaviour) {
                AnyView(
                    BehaviourView()
                        .environmentObject(preferenceStorage)
                )
            }
        ])
    }
    
    var respringButton: some View {
        Button {
            DeviceService().respring()
        } label: {
            PreferenceCell(cell: .respring)
        }
    }
}
