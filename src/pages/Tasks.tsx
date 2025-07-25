import React from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getTasks, completeTask } from '../api';
import { Task } from '../types';
import { Check, Clock } from 'lucide-react';
import { Button } from '../components/Button';

export const Tasks: React.FC = () => {
  const queryClient = useQueryClient();
  const { data: tasks, isLoading } = useQuery<Task[]>({
    queryKey: ['tasks'],
    queryFn: getTasks,
  });

  const completeMutation = useMutation({
    mutationFn: completeTask,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['tasks'] });
    },
  });

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-800 mb-8">Daily Tasks</h1>
        {isLoading ? (
          <div className="text-center">Loading...</div>
        ) : (
          <div className="space-y-4">
            {tasks?.map((task) => (
              <div key={task.id} className="bg-white rounded-xl shadow-lg p-6 flex items-center justify-between">
                <div>
                  <h2 className="text-lg font-semibold text-gray-800">{task.title}</h2>
                  <p className="text-gray-600">{task.description}</p>
                  <div className="flex items-center text-sm text-gray-500 mt-2">
                    <Clock className="w-4 h-4 mr-1" />
                    <span>Due: {new Date(task.dueDate).toLocaleDateString()}</span>
                  </div>
                </div>
                <Button
                  variant={task.status === 'completed' ? 'secondary' : 'primary'}
                  size="sm"
                  disabled={task.status === 'completed'}
                  onClick={() => completeMutation.mutate(task.id)}
                >
                  {task.status === 'completed' ? (
                    <><Check className="w-4 h-4 mr-1" /> Completed</>
                  ) : (
                    'Mark Complete'
                  )}
                </Button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
