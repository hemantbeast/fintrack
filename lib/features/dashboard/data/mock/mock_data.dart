const String balanceMockJson = '''
{
  "current": 5234.50,
  "income": 6500.00,
  "expenses": 1265.50
}
''';

const String transactionsMockJson = '''
[
  {
    "id": "1",
    "title": "Lunch at Cafe",
    "category": "Food",
    "amount": 25.50,
    "date": "2026-01-24T12:30:00.000Z",
    "type": "expense",
    "emoji": "🍔"
  },
  {
    "id": "2",
    "title": "Uber Ride",
    "category": "Transport",
    "amount": 18.00,
    "date": "2026-01-23T18:45:00.000Z",
    "type": "expense",
    "emoji": "🚕"
  },
  {
    "id": "3",
    "title": "Salary Deposit",
    "category": "Income",
    "amount": 3500.00,
    "date": "2026-01-23T09:00:00.000Z",
    "type": "income",
    "emoji": "💵"
  },
  {
    "id": "4",
    "title": "Grocery Shopping",
    "category": "Food",
    "amount": 85.50,
    "date": "2026-01-22T16:20:00.000Z",
    "type": "expense",
    "emoji": "🏪"
  },
  {
    "id": "5",
    "title": "Netflix Subscription",
    "category": "Entertainment",
    "amount": 15.99,
    "date": "2026-01-21T10:00:00.000Z",
    "type": "expense",
    "emoji": "🎮"
  }
]
''';
