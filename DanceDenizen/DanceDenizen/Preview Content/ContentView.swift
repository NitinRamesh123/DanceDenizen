import SwiftUI

struct ContentView: View {
    @State private var overallPoints: Int = 0
    @State private var dances: [String] = ["Gangnam Style", "NDP Song"]
    @State private var showCamera: Bool = false
    @State private var cameraViewModel = CameraViewModel()
    @State private var poseViewModel = PoseEstimationViewModel()
    @State private var selectedDance: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            if showCamera {
                // Camera + Pose Overlay
                ZStack {
                    CameraPreviewView(session: cameraViewModel.session)
                        .edgesIgnoringSafeArea(.top)
                    
                    PoseOverlayView(
                        bodyParts: poseViewModel.detectedBodyParts,
                        connections: poseViewModel.bodyConnections
                    )
                }
                .frame(height: 300)
                .transition(.move(edge: .top))
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Dances")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                    
                    ForEach(dances, id: \.self) { dance in
                        Button {
                            selectedDance = dance
                            withAnimation {
                                showCamera = true
                            }
                            Task {
                                await cameraViewModel.checkPermission()
                                cameraViewModel.delegate = poseViewModel
                            }
                        } label: {
                            HStack {
                                Text(dance)
                                Spacer()
                                Image(systemName: "play.circle")
                                    .foregroundColor(.blue)
                            }
                            .padding(8)
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(8)
                        }
                    }
                    
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("High Score: 100")
                        Text("High Score: 70")
                    }
                    .padding(8)
                    .background(Color.orange.opacity(0.3))
                    .cornerRadius(8)
                    
                    Button {
                        print("Search button tapped!")
                    } label: {
                        Text("Search")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 3)
                    }
                    .padding(.vertical, 10)
                    
                    Text("Overall Points: \(overallPoints)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                    
                    Text("Song Lyrics: (will add something here later)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 2)
                        )
                }
                .padding()
            }
        }
    }
}
#Preview {
    ContentView()
}
