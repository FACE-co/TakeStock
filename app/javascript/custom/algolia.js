// This File/Folder is placed outside of controllers as it is using Vanilla JS.
import algoliasearch from 'algoliasearch/lite';
import instantsearch from 'instantsearch.js';
import { searchBox, hits, clearRefinements } from 'instantsearch.js/es/widgets';

const initAlgolia = () => {
  const apiKey = document.body.dataset.algoliaPublicKey
  const searchClient = algoliasearch('K0X97I2FU8', apiKey);

  const search = instantsearch({
    indexName: 'Stock_development',
    searchClient,
  });

  search.addWidgets([

    searchBox({
      container: "#searchbox",
      placeholder: 'Filter Table',
      autofocus: true,
      templates: {

      },
    }),

    hits({
      container: "#hits",
      templates: {
        item(hit, { html }) {
          for (let i = 1; i < 10; i += 1) {
          const positiveOrNegativeChange = hit.yahooapi["regularMarketChange"] < 0
          const color = positiveOrNegativeChange ? 'text-rose-500' : 'text-emerald-500'
          const plusOrMinus = positiveOrNegativeChange ? '-' : '+'
          const absoluteNumber = (query) => {
            const result = parseFloat(Math.abs(query)).toFixed(2);
            return result
          };

          return html`
            <div class="group hover:bg-indigo-500 text-white cursor-pointer grid grid-cols-11">
              <div class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6 group-hover:text-white">${i++}</div>
              <div class="col-span-3 whitespace-nowrap px-3 py-4 text-sm text-gray-500 group-hover:text-white">${hit["name"]}</div>
              <div class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 group-hover:text-white">${hit["ticker"]}</div>
              <div class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 group-hover:text-white">${hit.yahooapi["regularMarketPrice"]}</div>
              <div class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 group-hover:text-white">${hit.yahooapi["regularMarketDayHigh"]}</div>
              <div class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 group-hover:text-white">${hit.yahooapi["regularMarketDayLow"]}</div>
              <div class='whitespace-nowrap px-3 py-4 text-sm ${color} group-hover:text-white'>${plusOrMinus}$ ${absoluteNumber(hit.yahooapi['regularMarketChange'])}</div>
              <div class='whitespace-nowrap px-3 py-4 text-sm ${color} group-hover:text-white'>${plusOrMinus} ${absoluteNumber(hit.yahooapi['postMarketChangePercent'])} %</div>
              <div data-controller="dropdown" class="flex items-center justify-center">
                <div>
                  <button type="button" data-action="dropdown#toggle click@window->dropdown#hide" class="fa-regular fa-plus ver:bg-gray-50 text-gray-300 border rounded-full focus:text-white h-5 w-5" id="menu-button" aria-expanded="true" aria-haspopup="true">
                  </button>
                </div>
              </div>
            </div>
          `;
          }
        },
      }
    }),

  ]);

  search.start();
  }

export { initAlgolia }
