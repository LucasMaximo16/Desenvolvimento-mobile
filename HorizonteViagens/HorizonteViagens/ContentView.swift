import SwiftUI

enum EstiloViagem {
    static let destaque = Color(red: 0.04, green: 0.42, blue: 0.45)
}

struct ContentView: View {
    @State private var favoritos = FavoritosStore()
    @State private var filtro = FiltroDestino.todos

    private var pacotes: [PacoteViagem] {
        PacoteViagem.exemplos.filter { filtro == .todos || $0.internacional == (filtro == .internacionais) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    CabecalhoExplorar()
                    Picker("Tipo de destino", selection: $filtro) {
                        ForEach(FiltroDestino.allCases) { filtro in
                            Text(filtro.rawValue).tag(filtro)
                        }
                    }
                    .pickerStyle(.segmented)
                    HStack {
                        Text("Sua próxima descoberta").font(.title3.bold())
                        Spacer()
                        Text("\(pacotes.count) pacotes").font(.caption).foregroundStyle(.secondary)
                    }
                    GradePacotes(pacotes: pacotes, favoritos: favoritos)
                    Text("Viagens para imaginar. Pacotes e valores demonstrativos.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                .padding(20)
                .frame(maxWidth: 1000)
                .frame(maxWidth: .infinity)
            }
            .background(.quinary.opacity(0.4))
            .navigationTitle("Explorar Viagens")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        FavoritosView(favoritos: favoritos)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "heart.fill")
                            Text("\(favoritos.ids.count)")
                                .monospacedDigit()
                        }
                        .font(.headline)
                        .fixedSize()
                    }
                    .accessibilityLabel("Meus Favoritos, \(favoritos.ids.count) pacotes")
                    .accessibilityIdentifier("abrirFavoritos")
                }
            }
            .navigationDestination(for: PacoteViagem.self) { pacote in
                DetalhesPacoteView(pacote: pacote, favoritos: favoritos)
            }
        }
        .tint(EstiloViagem.destaque)
    }
}

private enum FiltroDestino: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case nacionais = "Brasil"
    case internacionais = "Mundo"
    var id: Self { self }
}

private struct CabecalhoExplorar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("HORIZONTE VIAGENS", systemImage: "airplane")
                .font(.caption.weight(.bold)).tracking(2)
            Text("Colecione lugares.\nViva novas histórias.")
                .font(.title.bold())
            Text("Do seu próximo descanso à viagem dos sonhos.")
                .font(.subheadline)
        }
        .foregroundStyle(.white)
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color(red: 0.06, green: 0.23, blue: 0.34), EstiloViagem.destaque], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 26))
    }
}

struct GradePacotes: View {
    let pacotes: [PacoteViagem]
    let favoritos: FavoritosStore

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 290), spacing: 20)], spacing: 20) {
            ForEach(pacotes) { pacote in
                CartaoPacote(pacote: pacote, favoritos: favoritos)
            }
        }
    }
}

private struct CartaoPacote: View {
    let pacote: PacoteViagem
    let favoritos: FavoritosStore

    var body: some View {
        NavigationLink(value: pacote) {
            VStack(alignment: .leading, spacing: 0) {
                IlustracaoDestino(simbolo: pacote.imagemNome, internacional: pacote.internacional)
                    .frame(height: 165)
                    .overlay(alignment: .bottomLeading) {
                        Text(pacote.internacional ? "PELO MUNDO" : "DESCUBRA O BRASIL")
                            .font(.caption2.bold()).tracking(1.5)
                            .padding(8).background(.regularMaterial, in: Capsule()).padding(14)
                    }
                VStack(alignment: .leading, spacing: 10) {
                    Text(pacote.titulo).font(.title3.bold())
                    Label(pacote.local, systemImage: "mappin.and.ellipse")
                        .font(.subheadline).foregroundStyle(.secondary)
                    Label("\(pacote.diarias) diárias", systemImage: "moon")
                        .font(.caption).foregroundStyle(.secondary)
                    Divider()
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("por pessoa").font(.caption).foregroundStyle(.secondary)
                            Text(pacote.precoFormatado).font(.title2.bold()).foregroundStyle(EstiloViagem.destaque)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right").font(.headline).foregroundStyle(EstiloViagem.destaque)
                    }
                }
                .padding(18)
            }
            .background(.background, in: RoundedRectangle(cornerRadius: 22))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay { RoundedRectangle(cornerRadius: 22).strokeBorder(.quaternary) }
            .contentShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
        .overlay(alignment: .topTrailing) {
            BotaoFavorito(pacote: pacote, favoritos: favoritos).padding(12)
        }
    }
}

struct IlustracaoDestino: View {
    let simbolo: String
    let internacional: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: internacional ? [Color(red: 0.38, green: 0.43, blue: 0.67), Color(red: 0.83, green: 0.65, blue: 0.52)] : [Color(red: 0.23, green: 0.65, blue: 0.70), Color(red: 0.72, green: 0.85, blue: 0.72)], startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle().fill(.white.opacity(0.3)).frame(width: 90, height: 90)
                    .position(x: geometry.size.width * 0.78, y: geometry.size.height * 0.3)
                Ellipse().fill(.white.opacity(0.15))
                    .frame(width: geometry.size.width * 1.4, height: 140)
                    .position(x: geometry.size.width * 0.3, y: geometry.size.height)
                Image(systemName: simbolo)
                    .font(.system(size: 86, weight: .light))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.12), radius: 10, y: 6)
            }
        }
        .clipped()
        .accessibilityHidden(true)
    }
}

struct BotaoFavorito: View {
    let pacote: PacoteViagem
    let favoritos: FavoritosStore

    var body: some View {
        Button {
            favoritos.alternar(pacote)
        } label: {
            Image(systemName: favoritos.contem(pacote) ? "heart.fill" : "heart")
                .font(.title3.weight(.semibold))
                .foregroundStyle(favoritos.contem(pacote) ? Color.pink : EstiloViagem.destaque)
                .frame(width: 44, height: 44)
                .background(.regularMaterial, in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(favoritos.contem(pacote) ? "Remover dos favoritos" : "Adicionar aos favoritos"): \(pacote.titulo)")
        .accessibilityIdentifier("favorito-\(pacote.id)")
    }
}

struct FavoritosView: View {
    let favoritos: FavoritosStore
    @Environment(\.dismiss) private var dismiss

    private var pacotes: [PacoteViagem] {
        PacoteViagem.exemplos.filter { favoritos.contem($0) }
    }

    var body: some View {
        ScrollView {
            if pacotes.isEmpty {
                ContentUnavailableView {
                    Label("Sua próxima viagem começa aqui", systemImage: "heart")
                } description: {
                    Text("Toque no coração de um pacote para guardar seus destinos preferidos.")
                } actions: {
                    Button("Explorar viagens") { dismiss() }.buttonStyle(.borderedProminent)
                }
                .padding(.top, 60)
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Seus destinos favoritos, em um só lugar.").foregroundStyle(.secondary)
                    GradePacotes(pacotes: pacotes, favoritos: favoritos)
                }
                .padding(20)
                .frame(maxWidth: 1000)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Meus Favoritos")
        .background(.quinary.opacity(0.4))
    }
}

#Preview {
    ContentView()
}
