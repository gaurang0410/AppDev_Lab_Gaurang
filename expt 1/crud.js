// Array to hold student records
let records = [
    { id: 1, name: "Alice", grade: 85 },
    { id: 2, name: "Bob", grade: 90 }
];
// CREATE
function addRecord(name, grade) {
    const id = records.length ? Math.max(...records.map((r) => r.id)) + 1 : 1;
    const record = { id, name, grade };
    records.push(record);
    return record;
}
// READ
function getRecord(id) {
    return records.find((r) => r.id === id);
}
// UPDATE
function updateRecord(id, updates) {
    const idx = records.findIndex((r) => r.id === id);
    if (idx === -1)
        return null;
    records[idx] = Object.assign(Object.assign({}, records[idx]), updates);
    return records[idx];
}
// DELETE
function deleteRecord(id) {
    const before = records.length;
    records = records.filter((r) => r.id !== id);
    return records.length < before;
}
// DEMO (run examples)
console.log("Initial:", records);
console.log("Add:", addRecord("Charlie", 95));
console.log("Read (id=2):", getRecord(2));
console.log("Update (id=1, grade=88):", updateRecord(1, { grade: 88 }));
console.log("Delete (id=2):", deleteRecord(2));
console.log("Final:", records);
