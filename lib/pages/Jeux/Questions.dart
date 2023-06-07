
// class qui rassemble les questions
class Question {
  late final int id, answer;
  late final String question;
  late final List<String> options;
  
  Question({required this.id, required this.question, required this.answer, required this.options});

}

const List sample_data = [
  {
    "id":1,
    "question": "Anne Cathérine tchokonté a développé ",
    "options": ['Orange Money', 'Facebook', 'MobileMoney', 'Twitter'],
    "answer_index": 0,
  }, 

  {
    "id":2,
    "question": "Qui est Stella BITCHEBE",
    "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
    "answer_index": 1,
  }, 

  {
    "id":3,
    "question": "Ejara",
    "options": ["plateforme d’investissement mobile", 'Sociéte de Pétrole', 'Entreprise cormerciale', 'Pharmacie'],
    "answer_index": 0,
  },

  {
    "id":4,
    "question": "Quel est le nom du ministre des postes et Télécommunication au Cameroun",
    "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
    "answer_index": 1,
  },

  {
    "id":5,
    "question": "Quel est le nom du CEO de Caysti",
    "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
    "answer_index": 1,
  },

  {
    "id":6,
    "question": "Quand est-ce qu'on célèbre la journée internationale des filles dans les TIC",
    "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
    "answer_index": 1,
  },

  {
    "id":7,
    "question": "Quelle est le thème de la journée",
    "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
    "answer_index": 1,
  },

  // {
  //   "id":8,
  //   "question": "Qui est Stella BITCHEBE",
  //   "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
  //   "answer_index": 1,
  // },
  
  // {
  //   "id":9,
  //   "question": "Qui est Stella BITCHEBE",
  //   "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
  //   "answer_index": 1,
  // },

  // {
  //   "id":10,
  //   "question": "Qui est Stella BITCHEBE",
  //   "options": ['Mathématicienne', 'Chercheure en informatique', 'Ministre de la communication', 'Docteur en médécine'],
  //   "answer_index": 1,
  // },

];