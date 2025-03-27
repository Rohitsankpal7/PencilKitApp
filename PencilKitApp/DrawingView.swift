//
//  DrawingView.swift
//  PencilKitApp
//
//  Created by Rohit Sankpal on 27/03/25.
//

import SwiftUI
import PencilKit

import SwiftUI
import PencilKit

struct DrawingView: View {
    @StateObject private var viewModel = CanvasViewModel()

    var body: some View {
        VStack {
            CanvasView(viewModel: viewModel)
                .background(Color.white)
                .cornerRadius(10)
                .padding()

            HStack(spacing: 30) {
                // Tool Picker
                Button(action: {
                    viewModel.setTool(type: .pen)
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 30))
                }

                Button(action: {
                    viewModel.setTool(type: .marker)
                }) {
                    Image(systemName: "highlighter")
                        .font(.system(size: 30))
                }

                Button(action: {
                    viewModel.setEraser()
                }) {
                    Image(systemName: "eraser")
                        .font(.system(size: 30))
                }

                Button(action: {
                    viewModel.clearCanvas()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 30))
                }

                // Color Picker
                ColorPicker("", selection: $viewModel.selectedColor)
                    .labelsHidden()
                    .frame(width: 50, height: 50)
            }
            .padding()
        }
    }
}

// MARK: - Canvas View
struct CanvasView: UIViewRepresentable {
    @ObservedObject var viewModel: CanvasViewModel

    func makeUIView(context: Context) -> PKCanvasView {
        viewModel.canvasView.drawingPolicy = .anyInput
        viewModel.setTool(type: .pen)
        return viewModel.canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        viewModel.updateTool()
    }
}

// MARK: - ViewModel
class CanvasViewModel: ObservableObject {
    @Published var selectedColor: Color = .black {
        didSet {
            updateTool()
        }
    }

    let canvasView = PKCanvasView()

    private var inkType: PKInkingTool.InkType = .pen

    func setTool(type: PKInkingTool.InkType) {
        inkType = type
        updateTool()
    }

    func updateTool() {
        let uiColor = UIColor(selectedColor)
        let tool = PKInkingTool(inkType, color: uiColor, width: 5)
        canvasView.tool = tool
    }

    func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
    
    func setEraser() {
        canvasView.tool = PKEraserTool(.vector, width: 2.0)
    }
}
#Preview {
    DrawingView()
}
