import Foundation

struct Aluno: Identifiable {
    let id = UUID()
    let nome: String
    let nota1: Double
    let nota2: Double

    var media: Double { (nota1 + nota2) / 2 }
    var aprovado: Bool { media >= 7 }

    init(nome: String, nota1: String, nota2: String) throws {
        let nomeLimpo = nome.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nomeLimpo.isEmpty else { throw ErroCadastro.nomeVazio }
        guard let primeiraNota = Self.converterNota(nota1) else {
            throw ErroCadastro.notaInvalida(1)
        }
        guard let segundaNota = Self.converterNota(nota2) else {
            throw ErroCadastro.notaInvalida(2)
        }
        self.nome = nomeLimpo
        self.nota1 = primeiraNota
        self.nota2 = segundaNota
    }

    private static func converterNota(_ texto: String) -> Double? {
        let normalizado = texto.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard let nota = Double(normalizado), nota.isFinite, (0...10).contains(nota) else {
            return nil
        }
        return nota
    }
}

enum ErroCadastro: LocalizedError {
    case nomeVazio
    case notaInvalida(Int)

    var errorDescription: String? {
        switch self {
        case .nomeVazio:
            return "Informe o nome do aluno."
        case .notaInvalida(let numero):
            return "Informe a Nota \(numero) com um valor entre 0 e 10."
        }
    }
}
