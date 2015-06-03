var React = require('react');
var request = require('superagent');
var { Treemap, BarChart, } = require('react-d3');
var _ = require('lodash');

var App = React.createClass({
  getInitialState() {
    return {tags: null, commenters: null};
  },

  componentWillMount() {
    request.
      get('http://react-native-issues-api.herokuapp.com/tag-counts').
      end((err, result) => {
        if (!err) {
          this.setState({tags: result.body});
        } else {
          this.setState({error: true});
        }
      });

    request.
      get('http://react-native-issues-api.herokuapp.com/unique-commenters').
      end((err, result) => {
        if (!err) {
          this.setState({commenters: result.body});
        } else {
          this.setState({error: true});
        }
      });
  },

  render() {
    if (this.state.tags && this.state.commenters) {
      var allData = _.map(this.state.tags, (count, tag) => {
        return {label: tag, value: count};
      });

      var data = _.filter(allData, (datum) => {
        return datum.value > 1;
      });

      var otherData = _.filter(allData, (datum) => {
        return datum.value == 1;
      });

      var commenters = this.state.commenters;

      return (
        <div>
          <BarChart
            data={data}
            width={1200}
            height={400}
            fill={'#3182bd'}
            title='Issue Distribution' />

          <Treemap
            data={data}
            width={1200}
            height={400}
            textColor="#484848"
            fontSize="10px"
            title="Treemap" />

          <div>
            <h3>Others..</h3>

            <ul>{otherData.map((item) => { return <li>{item.label}</li> })}</ul>
          </div>

          <div>
            <h3>Sorted by unique commenters</h3>
            <ul>
              {
                commenters.map((item) => {
                  return (
                    <li>{item.unique_commenters} - {item.title}</li>
                  )
                })
              }
           </ul>
        </div>
        </div>
      )
    } else {
      return <h2>Loading...</h2>
    }
  }
});

module.exports = App;
