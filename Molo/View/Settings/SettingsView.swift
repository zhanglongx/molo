import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var env: AppEnvironment
    @State private var token: String = ""
    @State private var savedHint: String?

    var body: some View {
        Form {
            Section("TuShare") {
                SecureField("Token", text: $token)
                    .textContentType(.password)

                Button("保存 Token") {
                    env.tokenStore.writeToken(token.trimmingCharacters(in: .whitespacesAndNewlines))
                    savedHint = "已保存"
                }
                .buttonStyle(.borderedProminent)

                if let hint = savedHint {
                    Text(hint)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section("说明") {
                Text("本应用通过 TuShare Pro 的 HTTP API 拉取财报数据，并在本地缓存。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("设置")
        .onAppear {
            token = env.tokenStore.readToken() ?? ""
        }
    }
}
