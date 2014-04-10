import abc, numpy, scipy.stats
from enum import Enum

"""
Checks if key exists in hash
creates array if not and then adds
value regardless
"""
def _add_to_array_hash(tr_hash, value, key):
  _check_hash(tr_hash, [], key)
  tr_hash[key].append(value)
def _check_hash(tr_hash, value, key):
  if not tr_hash.has_key(key):
      tr_hash[key] = value 
class FeatureType(Enum):
  continuous  = 1
  discrete = 2
  

class Feature(object):
  MIN = 0.0001
  """
  Generic class to handle a prosterior feature
    stores if value is discrete or continuous
    stores list of points that make up feature
  """
  def __init__(self, name, feature_type):
    self.name = name
    self.feature_type = feature_type 
    self.training_size = 0
    self.training_counter = {}
    self.training_stats = {}

  """
  Write in concurrance with prob_feature
  written to prepare results for prob_feature when called
  """
  @abc.abstractmethod
  def train(self):
    raise RuntimeError("Must implement train!")

  """
  Used to get P(A|B) where
    A is probability of feature
    B is probability of classification
  """
  @abc.abstractmethod
  def prob_feature(self, value, classification):
    raise RuntimeError("Must implement predict!")

  """
  Used when training data is added to feature
  """
  @abc.abstractmethod
  def add_training_data(self, value, classification):
    raise RuntimeError("Must implement add_training_data!")

  def add_training_counter(self, classification):
    self.training_size += 1  
    if not self.training_counter.has_key(classification):
      self.training_counter[classification] = 0
    self.training_counter[classification] += 1


  
"""
For features that utilize continuous values
Prediction of feature is done using gaussian distribution
"""
class ContinuousFeature(Feature):
  def __init__(self, name):
    super(ContinuousFeature, self).__init__(name, FeatureType.continuous)
    self.training_list = {}
 
  def add_training_data(self, value, classification):
    self.add_training_counter(classification)
    _add_to_array_hash(self.training_list, value, classification)

  def train(self):
    tr_list = self.training_list
    # classification
    for key in tr_list.keys():
      tr_stat = {
        'mean':  numpy.mean(tr_list[key]),
        'std': numpy.std(tr_list[key])
      }
      self.training_stats[key] = tr_stat


  def prob_feature(self, value, classification):
    std = self.training_stats[classification]['std']
    mean = self.training_stats[classification]['mean']
    # use the gausian distribution to predict for cont variables
    return scipy.stats.norm(
        loc=mean, 
        scale=std).pdf(float(value))

"""
For features that utilize discrete values
Prediction of feature is done using 
(total of disc value for particular class)/ (total number of training points classified as particular class)
"""
class DiscreteFeature(Feature):
  def __init__(self, name):
    super(DiscreteFeature, self).__init__(name, FeatureType.discrete)
    self.training_values = {}

  def add_training_data(self, value, classification):
    self.add_training_counter(classification)
    tr_val = self.training_values 
    if not tr_val.has_key(classification):
      tr_val[classification] = {}
    if not tr_val[classification].has_key(value):
      tr_val[classification][value] = 0
    tr_val[classification][value] += 1

  def train(self):
    for classi in self.training_values.keys():
      self.training_stats[classi] = {}
      for discrete in self.training_values[classi].keys():
        self.training_stats[classi][discrete] = float(self.training_values[classi][discrete]) / float(self.training_counter[classi])

  def prob_feature(self, value, classification):
    if not self.training_stats[classification].has_key(value):
      return Feature.MIN
    return self.training_stats[classification][value]


class FeatureCollection:
  """ 
  Collection of all features for a single data row
  """
  def __init__(self):
    self.features = {} 
    # to calculate bayesian prior
    self.classifications = {} 

  def train(self):
    for feature_name in self.features.keys():
      self.features[feature_name].train()


  def add_feature(self, value, feature_name, feature_type, classification):
    _check_hash(self.classifications, classification, classification)
    if not self.features.has_key(feature_name):
      feat = None
      if feature_type == FeatureType.continuous:
        feat = ContinuousFeature(feature_name)
      elif feature_type == FeatureType.discrete:
        feat = DiscreteFeature(feature_name)
      else:
        raise RuntimeError("undefind feature type!")
      self.features[feature_name] = feat
    if feature_type == FeatureType.continuous :
      value = float(value)
    self.features[feature_name].add_training_data(value, classification) 


  def predict(self, data_value):
    value = 0
    highest_class = ''
    stats = {}
    for classification in self.classifications:
      prediction = 0.5 
      for feat in self.features:
        feature = self.features[feat]
        prediction *= feature.prob_feature(
            data_value[feat],
            classification)
        
      if prediction > value:
        value = prediction
        highest_class = classification
      stats[classification] = prediction
    return highest_class, stats

      

    

