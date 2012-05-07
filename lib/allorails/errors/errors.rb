module Allorails


  class AllopassApikitError < StandardError
  end

  class ApiConfAccountNotFoundError < StandardError
  end
  class ApiConfFileCorruptedError < StandardError
  end
  class ApiConfFileMissingError < StandardError
  end
  class ApiConfFileMissingSectionError < StandardError
  end
  class ApiFalseResponseSignatureError < StandardError
  end

  class ApiMissingHashFeatureError < StandardError
  end
  class ApiRemoteErrorError < StandardError
  end

  class ApiUnavailableResourceError < StandardError
  end
  class ApiWrongFormatResponseError < StandardError
  end
    
end