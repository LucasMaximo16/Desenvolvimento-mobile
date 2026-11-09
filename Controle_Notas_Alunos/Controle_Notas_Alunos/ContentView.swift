import SwiftUI

private let laranjaTurma = Color(red: 1, green: 0.54, blue: 0.12)

struct ContentView: View {
    @State private var alunos: [Aluno] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 48) {
                CabecalhoView()
                CadastroAlunoView { aluno in
                    alunos.append(aluno)
                }
                ResumoTurmaView(
                    total: alunos.count,
                    aprovados: alunos.filter(\.aprovado).count,
                    reprovados: alunos.filter { !$0.aprovado }.count
                )
                ListaAlunosView(alunos: alunos) { aluno in
                    alunos.removeAll { $0.id == aluno.id }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 32)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.background)
        .tint(laranjaTurma)
    }
}

private struct CabecalhoView: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 48))
                .foregroundStyle(laranjaTurma)
                .accessibilityHidden(true)
            Text("Minha Turma")
                .font(.largeTitle.bold())
            Text("Cadastre alunos e acompanhe os resultados.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 12)
    }
}

private struct CadastroAlunoView: View {
    let cadastrar: (Aluno) -> Void

    @State private var nome = ""
    @State private var nota1 = ""
    @State private var nota2 = ""
    @State private var mensagemErro: String?
    @FocusState private var campoFocado: Campo?

    private enum Campo: Hashable {
        case nome, nota1, nota2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Cadastrar aluno", systemImage: "person.badge.plus")
                .font(.title3.bold())
                .padding(.bottom, 4)

            VStack(alignment: .leading, spacing: 7) {
                Text("Nome do aluno").font(.subheadline.weight(.medium))
                TextField("Digite o nome completo", text: $nome)
                    .textContentType(.name)
                    .focused($campoFocado, equals: .nome)
                    .submitLabel(.next)
                    .onSubmit { campoFocado = .nota1 }
                    .accessibilityLabel("Nome do aluno")
                    .accessibilityIdentifier("nomeAluno")
                    .modifier(CampoTextoStyle())
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) {
                    campoNota("Nota 1", texto: $nota1, campo: .nota1)
                    campoNota("Nota 2", texto: $nota2, campo: .nota2)
                }
                VStack(spacing: 16) {
                    campoNota("Nota 1", texto: $nota1, campo: .nota1)
                    campoNota("Nota 2", texto: $nota2, campo: .nota2)
                }
            }

            if let mensagemErro {
                Label(mensagemErro, systemImage: "exclamationmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("erroCadastro")
            }

            Button(action: adicionarAluno) {
                Label("Cadastrar aluno", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(laranjaTurma, in: RoundedRectangle(cornerRadius: 15))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("cadastrarAluno")
        }
        .padding(.horizontal, 14)
    }

    private func campoNota(_ titulo: String, texto: Binding<String>, campo: Campo) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(titulo).font(.subheadline.weight(.medium))
            TextField("0 a 10", text: texto)
#if os(iOS) || os(visionOS)
                .keyboardType(.decimalPad)
#endif
                .focused($campoFocado, equals: campo)
                .submitLabel(campo == .nota1 ? .next : .done)
                .onSubmit {
                    if campo == .nota1 {
                        campoFocado = .nota2
                    } else {
                        adicionarAluno()
                    }
                }
                .accessibilityLabel(titulo)
                .accessibilityIdentifier(campo == .nota1 ? "nota1" : "nota2")
                .modifier(CampoTextoStyle())
        }
        .frame(minWidth: 100)
    }

    private func adicionarAluno() {
        do {
            let aluno = try Aluno(nome: nome, nota1: nota1, nota2: nota2)
            cadastrar(aluno)
            nome = ""
            nota1 = ""
            nota2 = ""
            mensagemErro = nil
            campoFocado = nil
        } catch {
            mensagemErro = error.localizedDescription
        }
    }
}

private struct CampoTextoStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .padding(10)
            .frame(minHeight: 44)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(.quaternary, lineWidth: 1)
            }
    }
}

private struct ResumoTurmaView: View {
    let total: Int
    let aprovados: Int
    let reprovados: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("Resumo da turma").font(.title3.bold())
            HStack(alignment: .top, spacing: 12) {
                IndicadorView(titulo: "Alunos", valor: total, simbolo: "person.3.fill", cor: .blue)
                IndicadorView(titulo: "Aprovados", valor: aprovados, simbolo: "checkmark.circle.fill", cor: .green)
                IndicadorView(titulo: "Reprovados", valor: reprovados, simbolo: "xmark.circle.fill", cor: .red)
            }
            .padding(.horizontal, 12)
        }
    }
}

private struct IndicadorView: View {
    let titulo: LocalizedStringKey
    let valor: Int
    let simbolo: String
    let cor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: simbolo)
                .font(.title2)
                .foregroundStyle(cor)
                .accessibilityHidden(true)
            Text(valor, format: .number)
                .font(.largeTitle.bold())
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

private struct ListaAlunosView: View {
    let alunos: [Aluno]
    let remover: (Aluno) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    Text("Alunos cadastrados").font(.title3.bold())
                    Spacer()
                    Text("\(alunos.count) registros")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Alunos cadastrados").font(.title3.bold())
                    Text("\(alunos.count) registros").font(.caption).foregroundStyle(.secondary)
                }
            }
            if alunos.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.rectangle.stack")
                        .font(.system(size: 44))
                        .accessibilityHidden(true)
                    Text("Nenhum aluno cadastrado")
                        .font(.subheadline.weight(.medium))
                    Text("Adicione o primeiro aluno pelo formulário acima.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(alunos) { aluno in
                        AlunoRowView(aluno: aluno) { remover(aluno) }
                    }
                }
            }
        }
    }
}

private struct AlunoRowView: View {
    let aluno: Aluno
    let remover: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                Text(aluno.nome)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(role: .destructive, action: remover) {
                    Image(systemName: "trash")
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)
                .accessibilityLabel("Remover \(aluno.nome)")
            }
            HStack(alignment: .top, spacing: 16) {
                NotaView(titulo: "Nota 1", valor: aluno.nota1)
                NotaView(titulo: "Nota 2", valor: aluno.nota2)
                NotaView(titulo: "Média", valor: aluno.media)
            }
            Label(
                aluno.aprovado ? "Aprovado" : "Reprovado",
                systemImage: aluno.aprovado ? "checkmark.circle.fill" : "xmark.circle.fill"
            )
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(aluno.aprovado ? Color.green : Color.red)
        }
        .padding(16)
        .background(.quinary, in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct NotaView: View {
    let titulo: LocalizedStringKey
    let valor: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo).font(.caption).foregroundStyle(.secondary)
            Text(valor, format: .number.precision(.fractionLength(1)).locale(Locale(identifier: "pt_BR")))
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ContentView()
}
