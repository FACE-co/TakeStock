// This File/Folder is placed outside of controllers as it is using Vanilla JS.
import algoliasearch from 'algoliasearch/lite';
import instantsearch from 'instantsearch.js';
import { searchBox, hits } from 'instantsearch.js/es/widgets';

const initAlgolia = () => {
  const apiKey = document.body.dataset.algoliaPublicKey
  const searchClient = algoliasearch('K0X97I2FU8', apiKey);

  const search = instantsearch({
    indexName: 'Stock_development',
    searchClient,
  });

  search.addWidgets([
    searchBox({
      container: "#searchbox"
    }),

    hits({
      container: "#hits"
    })
  ]);

  search.start();
  }

export { initAlgolia }
