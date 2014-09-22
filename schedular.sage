import os
import csv
import glob
import matplotlib
import random

files = [file for file in glob.glob('available.csv')]

for fle in files:
    f=open(fle,'r') 
    data = [[int(j) for j in row] for row in csv.reader(f)] 
    f.close() 
#    data = [[0 for e in range(20)] for e in range(20)]
    for e in range(len(data)):
        for i in range(len(data[e])):
            if data[e][i] == 0:
                data[e][i] = 20

    M = Matrix(data)

    
    tutornames = ['jt','dafydd','paul','vince','jason','james','hawa','long','carney','power','daisy','staden','lunn','pohl','thomson','awan']
    t1 = ['jt','dafydd','paul','james','hawa','long','carney','power','daisy','staden','lunn','pohl','thomson','awan']
    t2 = ['vince','jason']
    tdict = {}
    for i in range(len(tutornames)):
        tdict[tutornames[i]] = i
    
    slotnames = ['s1','x1','t1','y1','p1','u1','r1','w1','v1','z1','s2','x2','t2','y2','p2','u2','r2','w2','v2','z2']
    sk = [['s1','x1'],['t1','y1'],['p1','u1'],['r1','w1'],['v1','z1'],['s2','x2'],['t2','y2'],['p2','u2'],['r2','w2'],['v2','z2']]
    sdict = {}
    for i in range(len(slotnames)):
        sdict[slotnames[i]] = i

    slots = len(slotnames) 
    Tutors = len(tutornames)

    p = MixedIntegerLinearProgram()  
    w = p.new_variable(binary=True)
    
    p.set_objective(sum(w[(i,j)] for i in range(Tutors) for j in range(slots)))

    for i in t1:
        p.add_constraint(sum( M[(tdict[i],j)]*w[(tdict[i],j)] for j in range(slots)) == 2)
    for i in t2:
        p.add_constraint(sum( M[(tdict[i],j)]*w[(tdict[i],j)] for j in range(slots)) == 6)

    for j in range(slots):
        p.add_constraint(sum( w[(i,j)] for i in range(Tutors)) == 2)
    for i in tutornames:
        for k in sk:
            p.add_constraint(sum( w[(tdict[i],sdict[k2])] for k2 in k) <= 1)
        
    schedule = {}
    print 'Objective Value:', p.solve()
    for i, v in p.get_values(w).iteritems():
        if tutornames[i[0]] in schedule and v == 1:
            schedule[tutornames[i[0]]].append(slotnames[i[1]])  
        if not tutornames[i[0]] in schedule and v == 1:
            schedule[tutornames[i[0]]] = [slotnames[i[1]]]  
    
    for e in schedule:
        print e,schedule[e]
