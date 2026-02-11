import SwiftUI

struct ResultMapView: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        WaterBodyView(
            shape: vm.chosenShape,
            windDirection: vm.chosenDirection,
            windStrength: vm.chosenStrength,
            showOverlay: true
        )
    }
}
