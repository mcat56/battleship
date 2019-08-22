valid_row_coordinates = keys[start_index .. ship.length] 
  # check to make sure you don't go out of bounds
valid_column_coords   = keys[start_index * @columns .. ship.length times] 
if coordinates == valid_column_coords || coordinates == valid_row_coordinates
  return true
else 
  false
  