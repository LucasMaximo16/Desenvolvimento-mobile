import SwiftUI

struct DetalhesPacoteView: View {
    let pacote: PacoteViagem
    let favoritos: FavoritosStore
    @State private var mostrarReserva = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                IlustracaoDestino(simbolo: pacote.imagemNome, internacional: pacote.internacional)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                VStack(alignment: .leading, spacing: 10) {
                    Text(pacote.titulo).font(.largeTitle.bold())
                    Label(pacote.local, systemImage: "mappin.and.ellipse").foregroundStyle(.secondary)
                }
                ResumoItinerario(partida: pacote.dataPartida, retorno: pacote.dataChegada, diarias: pacote.diarias)
                VStack(alignment: .leading, spacing: 12) {
                    Label("Sua hospedagem", systemImage: "bed.double.fill").font(.title3.bold())
                    Text(pacote.informacoesHotel).foregroundStyle(.secondary)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.quinary, in: RoundedRectangle(cornerRadius: 20))
                Button {
                    favoritos.alternar(pacote)
                } label: {
                    Label(favoritos.contem(pacote) ? "Remover dos favoritos" : "Adicionar aos favoritos", systemImage: favoritos.contem(pacote) ? "heart.fill" : "heart")
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                Text("Pacote demonstrativo por pessoa em acomodação dupla. Passagens aéreas e passeios não incluídos.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .padding(20)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Detalhes do pacote")
        .safeAreaInset(edge: .bottom) {
            Button {
                mostrarReserva = true
            } label: {
                Text("Reservar • \(pacote.precoFormatado)")
                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("reservarPacote")
            .padding(16)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
            .background(.bar)
        }
        .alert("Vamos imaginar essa viagem?", isPresented: $mostrarReserva) {
            Button("Entendi", role: .cancel) { }
        } message: {
            Text("Você escolheu \(pacote.titulo), por \(pacote.precoFormatado) por pessoa. Esta é uma demonstração: nenhuma reserva ou cobrança foi realizada.")
        }
    }
}

private struct ResumoItinerario: View {
    let partida: String
    let retorno: String
    let diarias: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Seu roteiro").font(.title3.bold())
            LabeledContent { Text(partida) } label: { Label("Partida", systemImage: "airplane.departure") }
            Divider()
            LabeledContent { Text("\(diarias) diárias") } label: { Label("Duração", systemImage: "moon") }
            Divider()
            LabeledContent { Text(retorno) } label: { Label("Retorno", systemImage: "airplane.arrival") }
        }
        .padding(20)
        .background(EstiloViagem.destaque.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
    }
}
