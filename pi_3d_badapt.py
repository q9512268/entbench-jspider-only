from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

N = 3
Y = 5
ind = np.arange(N)
ynd = np.arange(Y)
width = 0.20
ywidth = 0.20

data = []

with open("dat/pi_3dbadapt.dat") as f:
  content = f.readlines()

for i in range(Y):
  data.append(content[i+1].split())
  data[i].pop(0)

## the bars

for x in [0,1,2]:
  for y in [0,1,2,3,4]:
    ax.bar3d(x+(2*width), y, 0, width, ywidth, float(data[y][(x*3)]), color='r', label="full_throttle")
    ax.bar3d(x+width, y, 0, width, ywidth, float(data[y][(x*3)+1]), color='b', label="managed")
    ax.bar3d(x, y, 0, width, ywidth, float(data[y][(x*3)+2]), color='g', label="energy_saver")

# axes and labels
ax.set_xlim(-width,len(ind)+width)
xTickMarks = ['energy_saver', 'managed', 'full_throttle']
ax.set_xticks(ind+(2*width))
xtickNames = ax.set_xticklabels(xTickMarks,verticalalignment='baseline',horizontalalignment='left')
plt.setp(xtickNames, rotation=-30, fontsize=9)
ax.xaxis._axinfo['label']['space_factor'] = 3
ax.set_xlabel("Application Data Mode", fontsize=10)

ax.set_ylim(-ywidth,5+ywidth)
ax.set_yticks(ynd+(2*ywidth))
ytickmarks = ['crypto', 'sunflow', 'video', 'camera', 'javaboy']
yticknames = ax.set_yticklabels(ytickmarks,verticalalignment='baseline',horizontalalignment='right')
plt.setp(yticknames, rotation=45, fontsize=9)
ax.yaxis._axinfo['label']['space_factor'] = 3
ax.set_ylabel("Benchmark", fontsize=10)


ax.set_zlim(0,1)
ax.set_zticklabels([],visible=False)
ax.set_zlabel("Energy Consumed", fontsize=9)
ax.zaxis._axinfo['label']['space_factor'] = 1

red_proxy = plt.Rectangle((0, 0), 1, 1, fc="r")
blue_proxy = plt.Rectangle((0, 0), 1, 1, fc="b")
green_proxy = plt.Rectangle((0, 0), 1, 1, fc="g")

ax.legend([red_proxy,blue_proxy,green_proxy],["full_throttle boot mode", "managed boot mode", "energy_saver boot mode"],fontsize=10)

ax.view_init(elev=4., azim=-152)

plt.show()

#plt.savefig("pi_dat/pi_3dbadapt.png")

#fig = plt.figure()
#ax = fig.add_subplot(111, projection='3d')
#for c, z in zip(['r', 'g', 'b', 'y'], [0, 1, 2, 3, 4]):
#    xs = np.arange(20)
#    ys = np.random.rand(20)

    # You can provide either a single color or an array. To demonstrate this,
    # the first bar of each set will be colored cyan.
#    cs = [c] * len(xs)
#    cs[0] = 'c'
#    ax.bar(xs, ys, zs=z, zdir='y', color=cs, alpha=0.8)

#ax.set_xlabel('X')
#ax.set_ylabel('Y')
#ax.set_zlabel('Z')

#plt.show()
