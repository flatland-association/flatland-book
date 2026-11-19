-- group-by-year.lua
local function get_year(bib_item)
  if bib_item.issued and bib_item.issued['date-parts'] then
    local parts = bib_item.issued['date-parts']
    if parts[1] and parts[1][1] then
      return pandoc.utils.stringify(parts[1][1])
    end
  end
  return "No Date"
end

function Pandoc(doc)
  -- Extract parsed references from external .bib files BEFORE running citeproc
  local refs = pandoc.utils.references(doc)
  local id_to_year = {}
  for _, item in ipairs(refs) do
    local id = pandoc.utils.stringify(item.id)
    id_to_year[id] = get_year(item)
  end

  -- Run Pandoc's built-in citeproc
  doc = pandoc.utils.citeproc(doc)

  local new_blocks = {}
  local refs_by_year = {}
  local years = {}

  -- Intercept the generated #refs div
  for _, block in ipairs(doc.blocks) do
    if block.t == "Div" and block.identifier == "refs" then
      for _, entry in ipairs(block.content) do
        local cite_id = entry.identifier:gsub("^ref%-", "")
        local year = id_to_year[cite_id] or "Other"

        if not refs_by_year[year] then
          refs_by_year[year] = {}
          table.insert(years, year)
        end
        table.insert(refs_by_year[year], entry)
      end

      -- Rebuild #refs with ## Year subheadings
      for _, year in ipairs(years) do
        table.insert(new_blocks, pandoc.Header(2, year))
        table.insert(new_blocks, pandoc.Div(refs_by_year[year], {class = "references csl-bib-body"}))
      end
    else
      table.insert(new_blocks, block)
    end
  end

  doc.blocks = new_blocks
  return doc
end