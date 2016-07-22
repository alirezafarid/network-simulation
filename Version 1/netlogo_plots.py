from matplotlib import pyplot as plt

def plotcols(fname, cols, headlen=19):
    '''
    fname: file name of netlogo export
    cols: which data columns you want to plot (start at 0)
    headlen: length (number of lines) of the netlogo file header (contains info not needed for the plot)
    '''
    colors = ['r', 'k', 'b'] # add more colors for plots with more than 3 columns
    mif = open(fname)
    for i in range(headlen):
        mif.readline()
    data = dict()
    for line in mif:
        values = [v.strip('"') for v in line.split(',')]
        for i in cols:
            xi = int(values[4 *i])
            yi = float(values[4*i +1])
            data.setdefault(i,[]).append((xi,yi))
    mif.close()
    
    #print data
    for i in cols:
        
        plt.plot([xi for xi,yi in data[i]], [yi for xi,yi in data[i]], colors[i])
        print sum([yi for xi,yi in data[i]])/len(data[i])

plotcols('scores_CC2.csv', [0,1,2])
#plotcols('GCCSize_100all.csv', [0],17)