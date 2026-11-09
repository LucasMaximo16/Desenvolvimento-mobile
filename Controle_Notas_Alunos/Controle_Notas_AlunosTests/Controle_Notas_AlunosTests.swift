import Testing
@testable import Controle_Notas_Alunos

struct Controle_Notas_AlunosTests {
    @Test func calculaMediaEAprovacaoNoLimite() throws {
        let aluno = try Aluno(nome: " Ana ", nota1: "6", nota2: "8")
        #expect(aluno.nome == "Ana")
        #expect(aluno.media == 7)
        #expect(aluno.aprovado)
    }

    @Test func reprovaAbaixoDeSete() throws {
        let aluno = try Aluno(nome: "Bruno", nota1: "6,9", nota2: "7")
        #expect(abs(aluno.media - 6.95) < 0.00001)
        #expect(!aluno.aprovado)
    }

    @Test func aceitaDecimaisELimites() throws {
        let aluno = try Aluno(nome: "Carla", nota1: " 8,5 ", nota2: "9.5")
        #expect(aluno.media == 9)
        let limites = try Aluno(nome: "Davi", nota1: "0", nota2: "10")
        #expect(limites.media == 5)
    }

    @Test(arguments: ["", " ", "-1", "10.1", "abc", "nan", "inf", "7,5,2"])
    func rejeitaNotasInvalidas(nota: String) {
        #expect(throws: ErroCadastro.self) {
            try Aluno(nome: "Ana", nota1: nota, nota2: "7")
        }
        #expect(throws: ErroCadastro.self) {
            try Aluno(nome: "Ana", nota1: "7", nota2: nota)
        }
    }

    @Test func rejeitaNomeEmBranco() {
        #expect(throws: ErroCadastro.self) {
            try Aluno(nome: " \n ", nota1: "7", nota2: "8")
        }
    }

    @Test func alunosComMesmoNomeTemIdentidadesDistintas() throws {
        let primeiro = try Aluno(nome: "Ana", nota1: "7", nota2: "8")
        let segundo = try Aluno(nome: "Ana", nota1: "7", nota2: "8")
        #expect(primeiro.id != segundo.id)
    }
}
