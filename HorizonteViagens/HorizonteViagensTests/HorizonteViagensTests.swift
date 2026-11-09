import Foundation
import Testing
@testable import HorizonteViagens

@MainActor
struct HorizonteViagensTests {
    @Test func favoritosPersistemESaoRemovidos() throws {
        let suite = "HorizonteTests-\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let pacote = try #require(PacoteViagem.exemplos.first)
        let store = FavoritosStore(defaults: defaults)
        #expect(!store.contem(pacote))
        store.alternar(pacote)
        #expect(store.ids.count == 1)
        let restaurado = FavoritosStore(defaults: defaults)
        #expect(restaurado.contem(pacote))
        restaurado.alternar(pacote)
        #expect(FavoritosStore(defaults: defaults).ids.isEmpty)
    }

    @Test func catalogoTemIdentidadesUnicasEDatasConsistentes() throws {
        let pacotes = PacoteViagem.exemplos
        #expect(Set(pacotes.map(\.id)).count == pacotes.count)
        #expect(pacotes.contains { $0.internacional })
        #expect(pacotes.contains { !$0.internacional })
        let formatador = DateFormatter()
        formatador.locale = Locale(identifier: "pt_BR")
        formatador.timeZone = TimeZone(secondsFromGMT: 0)
        formatador.dateFormat = "dd/MM/yyyy"
        for pacote in pacotes {
            let partida = try #require(formatador.date(from: pacote.dataPartida))
            let retorno = try #require(formatador.date(from: pacote.dataChegada))
            #expect(Int(retorno.timeIntervalSince(partida) / 86400) == pacote.diarias)
            #expect(pacote.preco > 0)
            #expect(pacote.precoFormatado.contains("R$"))
        }
    }
}
