import Foundation
import Observation

struct PacoteViagem: Identifiable, Hashable {
    let id: UUID
    let titulo: String
    let diarias: Int
    let local: String
    let dataPartida: String
    let dataChegada: String
    let informacoesHotel: String
    let imagemNome: String
    let preco: Double
    let internacional: Bool

    var precoFormatado: String {
        preco.formatted(.currency(code: "BRL").locale(Locale(identifier: "pt_BR")))
    }

    static let exemplos: [PacoteViagem] = [
        .init(id: UUID(uuid: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1)), titulo: "Dias de sol em Noronha", diarias: 5, local: "Fernando de Noronha, PE", dataPartida: "10/12/2026", dataChegada: "15/12/2026", informacoesHotel: "Pousada Brisa do Mar • Quarto duplo com ar-condicionado, café da manhã e piscina. Traslado de chegada incluído.", imagemNome: "beach.umbrella.fill", preco: 3890, internacional: false),
        .init(id: UUID(uuid: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2)), titulo: "Paris, uma história de amor", diarias: 7, local: "Paris, França", dataPartida: "12/01/2027", dataChegada: "19/01/2027", informacoesHotel: "Hôtel Lumière • Quarto duplo, café da manhã continental e Wi-Fi. Localização próxima ao metrô.", imagemNome: "building.2.fill", preco: 8490, internacional: true),
        .init(id: UUID(uuid: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3)), titulo: "O charme da Serra Gaúcha", diarias: 4, local: "Gramado, RS", dataPartida: "03/12/2026", dataChegada: "07/12/2026", informacoesHotel: "Hotel Araucárias • Suíte com aquecimento, café da manhã colonial, estacionamento e piscina coberta.", imagemNome: "tree.fill", preco: 2190, internacional: false),
        .init(id: UUID(uuid: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4)), titulo: "Aventura aos pés dos Andes", diarias: 6, local: "Santiago, Chile", dataPartida: "08/02/2027", dataChegada: "14/02/2027", informacoesHotel: "Hotel Cordillera • Quarto duplo com vista para a cidade, café da manhã, academia e Wi-Fi.", imagemNome: "mountain.2.fill", preco: 4590, internacional: true),
        .init(id: UUID(uuid: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5)), titulo: "Mar azul, alma leve", diarias: 5, local: "Maragogi, AL", dataPartida: "18/01/2027", dataChegada: "23/01/2027", informacoesHotel: "Resort Costa Azul • Quarto duplo, pensão completa, piscinas e acesso à praia. Bebidas cobradas separadamente.", imagemNome: "water.waves", preco: 3290, internacional: false),
        .init(id: UUID(uuid: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6)), titulo: "Sabores e ruas de Lisboa", diarias: 7, local: "Lisboa, Portugal", dataPartida: "05/03/2027", dataChegada: "12/03/2027", informacoesHotel: "Hotel Tejo • Quarto duplo, café da manhã e Wi-Fi. Próximo aos restaurantes e passeios do centro histórico.", imagemNome: "tram.fill", preco: 6990, internacional: true)
    ]
}

@MainActor
@Observable
final class FavoritosStore {
    private(set) var ids: Set<UUID>
    private let defaults: UserDefaults
    private let chave = "horizonte.favoritos"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        ids = Set((defaults.stringArray(forKey: chave) ?? []).compactMap(UUID.init(uuidString:)))
    }

    func contem(_ pacote: PacoteViagem) -> Bool {
        ids.contains(pacote.id)
    }

    func alternar(_ pacote: PacoteViagem) {
        if !ids.insert(pacote.id).inserted {
            ids.remove(pacote.id)
        }
        defaults.set(ids.map(\.uuidString).sorted(), forKey: chave)
    }
}
