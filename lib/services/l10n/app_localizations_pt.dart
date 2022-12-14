import 'app_localizations.dart';

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get search => 'Procurar';

  @override
  String get version => 'versão';

  @override
  String get tryAgain => 'Tente Novamente.';

  @override
  String get connectionError => 'Erro de Ligação!';

  @override
  String get exit => 'SAIR';

  @override
  String get scan => 'SCAN';

  @override
  String get pendingRecords => 'Registos Pendentes';

  @override
  String get badConnection => 'Ligação falhou';

  @override
  String get rightConnection => 'Ligado';

  @override
  String get contactsLabel => 'Contato responsável técnico\ndo evento para pedido de suporte:';

  @override
  String get eventSelectHint => 'Seleciona o evento';

  @override
  String get equipSelectHint => 'Seleciona o equipamento';

  @override
  String get passwordHint => 'Insere a palavra-passe';

  @override
  String get signIn => 'Registar';

  @override
  String get wrongPassword => 'A password inserida não está correta,\ntenta novamente.';

  @override
  String get fillAllFields => 'Todos os campos são obrigatórios,\ntenta novamente.';

  @override
  String get controlAccess => 'CONTROLO\nDE ACESSOS';

  @override
  String get reservedArea => 'Área Reservada';

  @override
  String get authorizedPeople => 'Só é permitida a entrada a pessoas autorizadas pela Trisimple';

  @override
  String get emailLabel => 'Para mais informações envie email para:';

  @override
  String get codeInsertLabel => 'Inserir CÓDIGO gravado no Chip da pulseira';

  @override
  String get condeInsertHint => 'Insere o código';

  @override
  String get approachNfc => 'Pode aproximar.';

  @override
  String get unavailableNfc => 'NFC INDISPONÍVEL';

  @override
  String ticketIsNotFromEvent(String eventName) {
    return 'Não foi encontrado nenhum bilhete para \n${eventName}, correspondente ao código lido';
  }

  @override
  String get unsupportedTag => 'A tag lida não é suportada!';

  @override
  String get tagLost => 'A tag foi perdida. \nMantenha a pulseira próxima até obter resultados.';

  @override
  String get platformError => 'Ocorreu um erro de plataforma.';

  @override
  String get processError => 'Ocorreu um erro durante o processo.';

  @override
  String get valid => 'VÁLIDO';

  @override
  String get invalid => 'INVÁLIDO';

  @override
  String get ticket => 'Bilhete';

  @override
  String get bracelet => 'Pulseira';

  @override
  String get error => 'Erro';

  @override
  String get noPendingData => 'Sem data pendente';

  @override
  String pendingEntranceDate(String dateTime) {
    return 'Data de Entrada: $dateTime ';
  }

  @override
  String get logoutTitle => 'Pretende Sair?';

  @override
  String get logoutContent => 'Confirme que não se encontram registos pendentes, que todos foram sincronizados. As configurações do evento e do equipamento vão ser eliminadas.';

  @override
  String get logoutConfirm => 'Sim, quero sair.';

  @override
  String get pendingText => 'Existem registos por comunicar...';

  @override
  String get pendingButton => 'Comunicar pendentes';
}
