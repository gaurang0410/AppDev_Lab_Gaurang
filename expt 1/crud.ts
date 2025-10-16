// Define a Student type
type Student = { id: number; name: string; grade: number };

// Array to hold student records
let records: Student[] = [
  { id: 1, name: "Alice", grade: 85 },
  { id: 2, name: "Bob", grade: 90 }
];

// CREATE
function addRecord(name: string, grade: number): Student {
  const id = records.length ? Math.max(...records.map((r: Student) => r.id)) + 1 : 1;
  const record: Student = { id, name, grade };
  records.push(record);
  return record;
}

// READ
function getRecord(id: number): Student | undefined {
  return records.find((r: Student) => r.id === id);
}

// UPDATE
function updateRecord(id: number, updates: Partial<Student>): Student | null {
  const idx = records.findIndex((r: Student) => r.id === id);
  if (idx === -1) return null;
  records[idx] = { ...records[idx], ...updates };
  return records[idx];
}

// DELETE
function deleteRecord(id: number): boolean {
  const before = records.length;
  records = records.filter((r: Student) => r.id !== id);
  return records.length < before;
}

// DEMO (run examples)
console.log("Initial:", records);
console.log("Add:", addRecord("Charlie", 95));
console.log("Read (id=2):", getRecord(2));
console.log("Update (id=1, grade=88):", updateRecord(1, { grade: 88 }));
console.log("Delete (id=2):", deleteRecord(2));
console.log("Final:", records);
