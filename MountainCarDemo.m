function  MountainCarDemo( maxepisodes )
%MountainCarDemo, the main function of the demo
%maxepisodes: maximum number of episodes to run the demo

% Mountain Car Problem with SARSA 
% Programmed in Matlab 
% by:
%  Jose Antonio Martin H. <jamartinh@fdi.ucm.es>
% 
% See Sutton & Barto book: Reinforcement Learning p.214


clc
clf
global f1 f2 store_Q store_value M N
figure(f1)
set(gcf,'BackingStore','off')  % for realtime inverse kinematics
set(gcf,'name','Reinforcement Learning Mountain Car')  % for realtime inverse kinematics
set(gco,'Units','data')


maxsteps    = 1000;              % maximum number of steps per episode
statelist   = BuildStateList();  % the list of states
actionlist  = BuildActionList(); % the list of actions

nstates     = size(statelist,1);
nactions    = size(actionlist,1);
Q           = BuildQTable( nstates,nactions );  % the Qtable

state_index = 1; 
for n = 1: N
    for m = 1: M
    	statelist_x(n,m) = statelist(state_index,1);
        statelist_v(n,m) = statelist(state_index,2);
        state_index = state_index + 1;
    end
end


alpha       = 0.5;   % learning rate
gamma       = 1.0;   % discount factor
epsilon     = 0.01;  % probability of a random action selection
grafica     = false; %true;% indicates if display the graphical interface

xpoints=[];
ypoints=[];
Policy_matrix    = zeros( nstates,nstates );
for i=1:maxepisodes    
    
    [total_reward,steps,Q ] = Episode( maxsteps, Q , alpha, gamma,epsilon,statelist,actionlist,grafica );    
    
    disp(['Espisode: ',int2str(i),'  Steps:',int2str(steps),'  Reward:',num2str(total_reward),' epsilon: ',num2str(epsilon)])
    
    epsilon = epsilon * 0.99;
    
    xpoints(i)=i-1;
    ypoints(i)=steps;
    figure(f1)
    subplot(2,1,1);    
    plot(xpoints,ypoints)      
    title(['Episode: ',int2str(i),' epsilon: ',num2str(epsilon)])    
    drawnow
    
    
   
    %if (i>200)
    if (i == 201||i == 230||i == 250)
        %grafica=true;
    else 
        grafica=false;
    end
    
    %if (i == 201||i == 230||i == 250)
	if (mod(i,100) == 0)  
        % plot action
        %{
        for M = 1: nstates
                       
            for N = 1: nactions
                
                 if (Q(M,N)>0)
                     Policy_matrix(M,N) = 1;
                 elseif (Q(M,N)<0) 
                     Policy_matrix(M,N) = -1;
                 else 
                     Policy_matrix(M,N) = 0;
                 end
            end
        end
        
        Q_action
        %}
        value_index=1;
        for n = 1: N
                       
            for m = 1: M
                
                for A = 1: nactions
                  store_Q(n,m,A) = Q(value_index,A);
                end
                
                store_value(n,m) = max(Q(value_index,:));
                value_index = value_index +1;
            end
            
        end
        %Q_shown
        % plot Q value
        figure(f2)
        for A = 1: nactions
            subplot(2,2,A)
                %surf(statelist_x,statelist_v,store_Q(:,:,A));
                %mesh(statelist_x,statelist_v,store_Q(:,:,A));
                surf(statelist_x,statelist_v,store_Q(:,:,A))
                xlabel('Position');
                ylabel('Velocity');
                title(strcat ('Action space: ',int2str(actionlist(A))));
        end
        subplot(2,2,4)
            surf(statelist_x,statelist_v,store_value(:,:))
            xlabel('Position');
            ylabel('Velocity');
            title(strcat ('Maximum Q Value in Action Space'));
	end
    
end






