import React, { useState, useEffect } from 'react';

// Sample tasks and info
const TASKS = [
  { id: 1, name: 'Give morning medication' },
  { id: 2, name: 'Help with breakfast' },
  { id: 3, name: 'Check blood pressure' },
];

const INFO = {
  1: {
    text: 'Use the blue pill from the left bottle. Give with water.',
    img: '/medication.jpg',
    video: null,
  },
  2: {
    text: 'Prepare oatmeal or cereal. Milk in fridge, bowls in cupboard.',
    img: null,
    video: null,
  },
  3: {
    text: 'Use the digital blood pressure monitor in the bathroom.',
    img: '/bp_monitor.jpg',
    video: '/bp_instructions.mp4',
  },
};

function App() {
  const [user, setUser] = useState(localStorage.getItem('carer') || '');
  const [showInfo, setShowInfo] = useState(false);
  const [selectedTask, setSelectedTask] = useState(null);
  const [checklist, setChecklist] = useState(() => {
    const saved = localStorage.getItem('checklist');
    return saved ? JSON.parse(saved) : {};
  });

  const today = new Date().toISOString().slice(0, 10);

  // Save checklist changes
  useEffect(() => {
    localStorage.setItem('checklist', JSON.stringify(checklist));
  }, [checklist]);

  // Simple login
  function handleLogin(e) {
    e.preventDefault();
    const name = e.target.carer.value.trim();
    if (name) {
      setUser(name);
      localStorage.setItem('carer', name);
    }
  }

  function handleCheck(taskId) {
    setChecklist({
      ...checklist,
      [`${today}_${taskId}`]: {
        done: true,
        carer: user,
        time: new Date().toLocaleTimeString(),
      },
    });
  }

  if (!user) {
    return (
      <div className="flex flex-col items-center justify-center h-screen p-4">
        <form onSubmit={handleLogin} className="bg-white p-6 rounded shadow w-full max-w-xs">
          <h1 className="text-xl mb-4 text-center">Carer Login</h1>
          <input
            name="carer"
            placeholder="Enter your name"
            className="w-full p-2 border rounded mb-4"
            required
            autoFocus
          />
          <button type="submit" className="w-full bg-blue-500 text-white py-2 rounded">Login</button>
        </form>
      </div>
    );
  }

  return (
    <div className="bg-gray-100 min-h-screen p-4">
      <div className="max-w-md mx-auto bg-white shadow rounded p-4">
        <header className="flex justify-between items-center mb-4">
          <span className="font-semibold text-lg">Checklist for {today}</span>
          <button onClick={() => setShowInfo(!showInfo)} className="text-blue-600 underline">
            {showInfo ? 'Back to Checklist' : 'Info'}
          </button>
        </header>
        {!showInfo ? (
          <ul>
            {TASKS.map((task) => {
              const key = `${today}_${task.id}`;
              const done = checklist[key]?.done;
              return (
                <li key={task.id} className="flex items-center mb-4">
                  <input
                    type="checkbox"
                    checked={!!done}
                    disabled={done}
                    onChange={() => handleCheck(task.id)}
                    className="h-6 w-6 mr-3"
                  />
                  <span className={done ? 'line-through text-gray-500' : ''}>{task.name}</span>
                  {done && (
                    <span className="ml-auto text-xs text-green-700">
                      ✔ by {checklist[key].carer} at {checklist[key].time}
                    </span>
                  )}
                  <button
                    className="ml-2 text-xs text-blue-500 underline"
                    onClick={() => { setSelectedTask(task.id); setShowInfo(true); }}
                  >?</button>
                </li>
              );
            })}
          </ul>
        ) : (
          selectedTask ? (
            <div>
              <button className="mb-2 text-blue-500 underline" onClick={() => setSelectedTask(null)}>← Back</button>
              <h2 className="font-bold mb-2">{TASKS.find(t => t.id === selectedTask).name}</h2>
              <p>{INFO[selectedTask]?.text}</p>
              {INFO[selectedTask]?.img && (
                <img src={INFO[selectedTask].img} alt="instruction" className="my-2 w-full rounded" />
              )}
              {INFO[selectedTask]?.video && (
                <video src={INFO[selectedTask].video} controls className="my-2 w-full rounded" />
              )}
            </div>
          ) : (
            <div>
              <h2 className="font-bold mb-2">Task Instructions</h2>
              <ul>
                {TASKS.map(task => (
                  <li key={task.id}>
                    <button
                      className="text-blue-500 underline mb-2"
                      onClick={() => setSelectedTask(task.id)}
                    >
                      {task.name}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          )
        )}
      </div>
    </div>
  );
}

export default App;
