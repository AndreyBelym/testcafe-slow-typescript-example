#!/bin/bash

rm -rf fixture
mkdir -p fixture/src/modules

for f in {a..z}; do
  echo "export const $f = {}" > fixture/src/modules/$f.ts
  echo "export { $f } from './$f'" >> fixture/src/modules/index.ts
done

echo "import 'testcafe'
import * as modules from './modules'

// prevent dead code removal
modules

fixture('foo')
test('foo', async (t) => t.expect(true).eql(true))
" > fixture/src/index.ts