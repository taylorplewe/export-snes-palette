local pal = app.sprite.palettes[1]

function rgbTo15Bit(r, g, b)
	return (r>>3) | ((g>>3) << 5) | ((b>>3) << 10)
end

-- warn if >256 colors
if #pal > 256 then
	app.alert{ title='Warning - Export SNES Palette', text='The palette has more than 256 colors. Only the first 256 colors will be exported.' }
end

-- output file dialog
exportDlg = Dialog('Export SNES Palette')
	:file{
		id='outFile',
		label='Out file (.bin):',
		save=true,
		title='Out file (.bin)',
		filetypes={'bin'},
		onchange=updateExportDlg,
	}
	:button{
		id='export',
		text='Export',
		enabled=false,
		onclick=export,
	}
	:button{
		text='Cancel',
	}
	:show{ wait=false }

function updateExportDlg()
	if #exportDlg.data.outFile ~= 0 then
		exportDlg:modify{ id='export', enabled=true }
	else
		exportDlg:modify{ id='export', enabled=false }
	end
end

function export()
	-- try to open output file
	local outFileName = exportDlg.data.outFile
	local outFile = io.open(exportDlg.data.outFile, "wb")
	if not outFile then
		app.alert{ title='File open error', text={ 'Could not open file:', '', outFileName, '' } }
		return
	end
	
	-- write CGRAM binary to file
	for colInd=0, #pal-1 do
		local col = pal:getColor(colInd)
		local snesCol = rgbTo15Bit(col.red, col.green, col.blue)
		outFile:write(string.char(snesCol&0xff, snesCol>>8))
	end

	-- wrap up
	outFile:close()
	exportDlg:close()
	app.alert{ title='Export Success', text={ 'SNES CGRAM (palette) binary successfully written to:', '', outFileName, '' } }
end