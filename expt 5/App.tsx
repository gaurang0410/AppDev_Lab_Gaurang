// App.js
// Simple, persistent to‑do list using Expo + React Native + AsyncStorage
// Features: add, toggle complete, edit, delete, filter (All/Active/Done), and local persistence

import React, { useEffect, useMemo, useRef, useState } from 'react';
import {
  SafeAreaView,
  View,
  Text,
  TextInput,
  FlatList,
  TouchableOpacity,
  Pressable,
  Keyboard,
  Alert,
  StyleSheet,
  Platform,
} from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

const STORAGE_KEY = 'RN_TODO_APP_TASKS_V1';

export default function App() {
  const [tasks, setTasks] = useState([]); // {id, text, done, createdAt}
  const [filter, setFilter] = useState('all'); // 'all' | 'active' | 'done'
  const [input, setInput] = useState('');
  const inputRef = useRef(null);

  // Load saved tasks on mount
  useEffect(() => {
    (async () => {
      try {
        const raw = await AsyncStorage.getItem(STORAGE_KEY);
        if (raw) setTasks(JSON.parse(raw));
      } catch (e) {
        console.warn('Failed to load tasks', e);
      }
    })();
  }, []);

  // Persist tasks whenever they change
  useEffect(() => {
    AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(tasks)).catch(() => {});
  }, [tasks]);

  const filtered = useMemo(() => {
    switch (filter) {
      case 'active':
        return tasks.filter(t => !t.done);
      case 'done':
        return tasks.filter(t => t.done);
      default:
        return tasks;
    }
  }, [tasks, filter]);

  function addTask() {
    const text = input.trim();
    if (!text) return;
    const newTask = {
      id: Date.now().toString(),
      text,
      done: false,
      createdAt: new Date().toISOString(),
    };
    setTasks(prev => [newTask, ...prev]);
    setInput('');
    inputRef.current?.blur();
    Keyboard.dismiss();
  }

  function toggleTask(id) {
    setTasks(prev => prev.map(t => (t.id === id ? { ...t, done: !t.done } : t)));
  }

  function deleteTask(id) {
    setTasks(prev => prev.filter(t => t.id !== id));
  }

  function clearCompleted() {
    const count = tasks.filter(t => t.done).length;
    if (!count) return;
    Alert.alert('Clear completed?', `This will remove ${count} task(s).`, [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Clear', style: 'destructive', onPress: () => setTasks(prev => prev.filter(t => !t.done)) },
    ]);
  }

  function startEdit(id) {
    setTasks(prev => prev.map(t => (t.id === id ? { ...t, isEditing: true, draft: t.text } : t)));
  }

  function changeDraft(id, value) {
    setTasks(prev => prev.map(t => (t.id === id ? { ...t, draft: value } : t)));
  }

  function saveEdit(id) {
    setTasks(prev =>
      prev.map(t => {
        if (t.id !== id) return t;
        const text = (t.draft ?? '').trim();
        if (!text) return t; // ignore empty save
        const { draft, isEditing, ...rest } = t;
        return { ...rest, text };
      }),
    );
  }

  function cancelEdit(id) {
    setTasks(prev => prev.map(t => (t.id === id ? { ...t, isEditing: false, draft: undefined } : t)));
  }

  const Item = ({ item }) => {
    if (item.isEditing) {
      return (
        <View style={styles.item}>
          <TextInput
            value={item.draft}
            onChangeText={v => changeDraft(item.id, v)}
            autoFocus
            style={[styles.input, styles.editInput]}
            placeholder="Edit task"
            returnKeyType="done"
            onSubmitEditing={() => saveEdit(item.id)}
          />
          <View style={styles.row}>
            <TouchableOpacity style={[styles.btn, styles.save]} onPress={() => saveEdit(item.id)}>
              <Text style={styles.btnText}>Save</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.btn, styles.cancel]} onPress={() => cancelEdit(item.id)}>
              <Text style={styles.btnText}>Cancel</Text>
            </TouchableOpacity>
          </View>
        </View>
      );
    }

    return (
      <View style={styles.item}>
        <Pressable onPress={() => toggleTask(item.id)} style={styles.checkbox}>
          {item.done ? <Text style={styles.checkmark}>✓</Text> : null}
        </Pressable>
        <Text style={[styles.itemText, item.done && styles.itemTextDone]} numberOfLines={3}>
          {item.text}
        </Text>
        <View style={styles.actions}>
          <TouchableOpacity style={[styles.smallBtn]} onPress={() => startEdit(item.id)}>
            <Text style={styles.smallBtnText}>Edit</Text>
          </TouchableOpacity>
          <TouchableOpacity style={[styles.smallBtn]} onPress={() => deleteTask(item.id)}>
            <Text style={[styles.smallBtnText, { opacity: 0.9 }]}>Del</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  };

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.container}>
        <Text style={styles.title}>To‑Do</Text>

        <View style={styles.addBox}>
          <TextInput
            ref={inputRef}
            style={styles.input}
            placeholder="Add a task…"
            value={input}
            onChangeText={setInput}
            returnKeyType="done"
            onSubmitEditing={addTask}
          />
          <TouchableOpacity style={[styles.btn, styles.addBtn]} onPress={addTask}>
            <Text style={styles.btnText}>Add</Text>
          </TouchableOpacity>
        </View>

        <View style={styles.filters}>
          {['all', 'active', 'done'].map(f => (
            <TouchableOpacity
              key={f}
              style={[styles.filterChip, filter === f && styles.filterChipActive]}
              onPress={() => setFilter(f)}
            >
              <Text style={[styles.filterText, filter === f && styles.filterTextActive]}>
                {f.charAt(0).toUpperCase() + f.slice(1)}
              </Text>
            </TouchableOpacity>
          ))}
          <View style={{ flex: 1 }} />
          <TouchableOpacity style={[styles.btn, styles.clearBtn]} onPress={clearCompleted}>
            <Text style={styles.btnText}>Clear Done</Text>
          </TouchableOpacity>
        </View>

        <FlatList
          data={filtered}
          keyExtractor={item => item.id}
          renderItem={({ item }) => <Item item={item} />}
          contentContainerStyle={styles.list}
          keyboardShouldPersistTaps="handled"
          ListEmptyComponent={() => (
            <Text style={styles.empty}>No tasks here. Add one above!</Text>
          )}
        />

        <Text style={styles.footer}>
          {tasks.filter(t => !t.done).length} task(s) remaining
        </Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#0B0B0F' },
  container: { flex: 1, padding: 16, gap: 12 },
  title: {
    fontSize: 32,
    fontWeight: '800',
    color: '#FFFFFF',
    letterSpacing: 0.5,
    marginTop: Platform.OS === 'android' ? 8 : 0,
  },
  addBox: { flexDirection: 'row', gap: 8, alignItems: 'center' },
  input: {
    flex: 1,
    backgroundColor: '#17171F',
    color: '#FFFFFF',
    paddingHorizontal: 14,
    paddingVertical: 12,
    borderRadius: 12,
    fontSize: 16,
    borderWidth: 1,
    borderColor: '#2A2A36',
  },
  editInput: { marginRight: 8 },
  btn: {
    paddingHorizontal: 14,
    paddingVertical: 10,
    borderRadius: 12,
    borderWidth: 1,
  },
  addBtn: { backgroundColor: '#4F46E5', borderColor: '#4F46E5' },
  save: { backgroundColor: '#16A34A', borderColor: '#16A34A' },
  cancel: { backgroundColor: '#334155', borderColor: '#334155', marginLeft: 8 },
  clearBtn: { backgroundColor: '#334155', borderColor: '#334155' },
  btnText: { color: '#FFFFFF', fontWeight: '600' },
  filters: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  filterChip: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 999,
    borderWidth: 1,
    borderColor: '#2A2A36',
    backgroundColor: '#0F0F16',
  },
  filterChipActive: { backgroundColor: '#1F1F2A', borderColor: '#4F46E5' },
  filterText: { color: '#9CA3AF', fontWeight: '600' },
  filterTextActive: { color: '#E5E7EB' },
  list: { paddingVertical: 8 },
  item: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    backgroundColor: '#12121A',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: '#222235',
    marginBottom: 10,
    gap: 10,
  },
  checkbox: {
    width: 24,
    height: 24,
    borderRadius: 6,
    borderWidth: 2,
    borderColor: '#4F46E5',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#0F0F16',
  },
  checkmark: { color: '#FFFFFF', fontSize: 16, fontWeight: '800' },
  itemText: { flex: 1, color: '#E5E7EB', fontSize: 16 },
  itemTextDone: { textDecorationLine: 'line-through', color: '#9CA3AF' },
  actions: { flexDirection: 'row', gap: 6 },
  smallBtn: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#2A2A36',
    backgroundColor: '#1B1B27',
  },
  smallBtnText: { color: '#D1D5DB', fontWeight: '700', fontSize: 12 },
  empty: { textAlign: 'center', color: '#9CA3AF', marginTop: 24 },
  footer: { textAlign: 'center', color: '#6B7280', marginVertical: 12 },
});
