## Heroku PG Dump

Heroku PG Dump is a small rake task that connects to a Postgres database, dumps it and pushes the dump to an S3 bucket of your choice. It'll also post a message to Slack when the dump has been completed. It's designed to run on Heroku so you can use the [Heroku Scheduler](https://addons.heroku.com/scheduler) to automatically dump your database every day!

## Deploy to Heroku
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Once the app has been setup don't forget to add the task `rake postgres:dump` to the [Scheduler](https://addons.heroku.com/scheduler)

## Copyright / License

Copyright 2015 James Harker

Licensed under the GNU General Public License Version 2.0 (or later);
you may not use this work except in compliance with the License.
You may obtain a copy of the License in the LICENSE file, or at:

   http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.