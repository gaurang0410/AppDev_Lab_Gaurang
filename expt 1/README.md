# CRUD Example in TypeScript & JavaScript

This project demonstrates simple **CRUD operations** (Create, Read, Update, Delete) on an array.

---

## Files
- `crud.ts` → TypeScript source code
- `crud.js` → JavaScript compiled code
- `README.md` → This file

---

## How to Run

### Using ts-node (TypeScript directly)
```bash
ts-node crud.ts
```

### Or compile & run JavaScript
```bash
tsc crud.ts --target es2015
node crud.js
```

---

## Expected Output
```
Initial: [ { id: 1, name: 'Alice', grade: 85 }, { id: 2, name: 'Bob', grade: 90 } ]
Add: { id: 3, name: 'Charlie', grade: 95 }
Read (id=2): { id: 2, name: 'Bob', grade: 90 }
Update (id=1, grade=88): { id: 1, name: 'Alice', grade: 88 }
Delete (id=2): true
Final: [ { id: 1, name: 'Alice', grade: 88 }, { id: 3, name: 'Charlie', grade: 95 } ]
```

---

## Experiment
This program shows how to:
- Add a record  
- Read a record by ID  
- Update an existing record  
- Delete a record  
