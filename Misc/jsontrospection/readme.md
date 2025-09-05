## jsontrospection
A quick tool to provide an introspection into a given json object.

## Usage

### Creating a schema

```
python3 jsontrospection.py x.txt
Schema tree for x.txt:

└── company: object
    ├── name: string
    ├── founded: number
    ├── employees: array
    │   └── [array items]: object
    │       ├── id: number
    │       ├── name: string
    │       ├── roles: array
    │       │   └── [array items]: string
    │       └── profile: object
    │           ├── email: string
    │           ├── active: boolean
    │           └── projects: array
    │               └── [array items]: object
    │                   ├── project_id: string
    │                   ├── title: string
    │                   ├── status: string
    │                   └── tasks: array
    │                       └── [array items]: object
    │                           ├── task_id: string
    │                           ├── desc: string
    │                           └── completed: boolean
    ├── departments: object
    │   ├── engineering: object
    │   │   ├── head: string
    │   │   ├── budget: number
    │   │   └── teams: array
    │   │       └── [array items]: object
    │   │           ├── team_id: string
    │   │           ├── focus: string
    │   │           └── members: array
    │   │               └── [array items]: string
    │   └── hr: object
    │       ├── head: string
    │       ├── budget: number
    │       └── policies: object
    │           ├── vacation_days: number
    │           ├── remote_work: boolean
    │           └── benefits: array
    │               └── [array items]: string
    └── offices: array
        └── [array items]: object
            ├── location: string
            └── address: object
                ├── street: string
                ├── city: string
                └── zip: string
```

### traversing the json object 

```
python3 jsontrospection.py x.txt -p company.employees
Value: [
  {
    "id": 1,
    "name": "Alice",
    "roles": [
      "admin",
      "developer"
    ],
    "profile": {
      "email": "alice@techcorp.com",
      "active": true,
      "projects": [
        {
          "project_id": "P100",
          "title": "AI Research",
          "status": "ongoing",
          "tasks": [
            {
              "task_id": "T1",
              "desc": "Build ML model",
              "completed": false
            },
            {
              "task_id": "T2",
              "desc": "Collect dataset",
              "completed": true
            }
          ]
        },
        {
          "project_id": "P200",
          "title": "Web Platform",
          "status": "completed",
          "tasks": [
            {
              "task_id": "T3",
              "desc": "Design UI",
              "completed": true
            },
            {
              "task_id": "T4",
              "desc": "Backend API",
              "completed": true
            }
          ]
        }
      ]
    }
  },
  {
    "id": 2,
    "name": "Bob",
    "roles": [
      "manager"
    ],
    "profile": {
      "email": "bob@techcorp.com",
      "active": false,
      "projects": []
    }
  }
]
Access Path: json['company']['employees']
```

```
python3 jsontrospection.py x.txt -p company.employees.id --all
Results:
- Index 0 -> Value: 1
  Path: json['company']['employees'][0]['id']
- Index 1 -> Value: 2
  Path: json['company']['employees'][1]['id']
```

```
python3 jsontrospection.py x.txt -p company.employees.0
Value: {
  "id": 1,
  "name": "Alice",
  "roles": [
    "admin",
    "developer"
  ],
  "profile": {
    "email": "alice@techcorp.com",
    "active": true,
    "projects": [
      {
        "project_id": "P100",
        "title": "AI Research",
        "status": "ongoing",
        "tasks": [
          {
            "task_id": "T1",
            "desc": "Build ML model",
            "completed": false
          },
          {
            "task_id": "T2",
            "desc": "Collect dataset",
            "completed": true
          }
        ]
      },
      {
        "project_id": "P200",
        "title": "Web Platform",
        "status": "completed",
        "tasks": [
          {
            "task_id": "T3",
            "desc": "Design UI",
            "completed": true
          },
          {
            "task_id": "T4",
            "desc": "Backend API",
            "completed": true
          }
        ]
      }
    ]
  }
}
Access Path: json['company']['employees'][0]
```
