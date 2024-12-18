local pal = app.sprite.palettes[1]
print('num colors in palette', #pal)
print('second color', pal:getColor(1))

for colInd=0, #pal do
	local col = pal:getColor(colInd)
	print('red', col.red)
	print('green', col.green)
	print('blue', col.blue)
	print('\n')
end