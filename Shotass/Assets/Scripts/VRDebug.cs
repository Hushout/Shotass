using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.XR;
using UnityEngine.XR.Interaction.Toolkit;

public class VRDebug : MonoBehaviour
{
    public enum DisplayMode
    {
        Foreground,
        Background,
        None
    }
    static VRDebug _instance = null;
    private static DisplayMode _displayMode = DisplayMode.None;

    
    public GameObject _textOutputGameObjectContainer;
    public GameObject _textOutputGameObjectOutBoundsContainer;
    
    public GameObject _textOutputGameObject;
    public GameObject _textOutputGameObjectOutBounds;
    
    public TextMeshProUGUI _textOutput;
    public TextMeshProUGUI _textOutputOutBounds;
    
    public GameObject controllerGameObject;
    public ActionBasedController controller;
    
    
    void Start()
    {
        if (_textOutputGameObject == null)
        {
            VRDebug.Log("[VRDebug]: Can not start without a TextMesh GameObject");
            return;
        }

        if (_instance != null)
        {
            Debug.Log("[VRDebug]: There are more than one VRDebug instances in this scene");
            return;
        }
        try
        {
            _textOutput = _textOutputGameObject.GetComponent<TextMeshProUGUI>();
            _textOutputOutBounds = _textOutputGameObjectOutBounds.GetComponent<TextMeshProUGUI>();
            VRDebug._instance = this;
            InitController();
            NextDisplayMode();
            NextDisplayMode();
        } catch (Exception e)
        {
            Debug.Log("Error: " + e);
        }
    }

    public void InitController()
    {
        controller = controllerGameObject.GetComponent<ActionBasedController>();
        controller.activateAction.action.performed += ctx => OnInputSelectPress();
    }
    
    public void OnInputSelectPress()
    {
        NextDisplayMode();
    }

    public void DisplayLog(string text, Color color)
    {
        _textOutput.color = color;
        if (_textOutputGameObjectContainer.active)
        {
            _textOutput.text += text + "\n";
            KeepTrackingBottom(_textOutput);
        }

        if (_textOutputGameObjectOutBoundsContainer)
        {
            _textOutputOutBounds.text += text + "\n";
            KeepTrackingBottom(_textOutputOutBounds);
        }
    }

    public static void NextDisplayMode()
    {
        
        if (_displayMode == DisplayMode.None)
        {
            _displayMode = DisplayMode.Foreground;
            _instance._textOutputGameObjectContainer.SetActive(true);
            _instance._textOutputGameObjectOutBoundsContainer.SetActive(false);
        } else if (_displayMode == DisplayMode.Foreground)
        {
            _displayMode = DisplayMode.Background;
            _instance._textOutputGameObjectContainer.SetActive(false);
            _instance._textOutputGameObjectOutBoundsContainer.SetActive(true);
        } else if (_displayMode == DisplayMode.Background)
        {
            _displayMode = DisplayMode.None;
            _instance._textOutputGameObjectContainer.SetActive(false);
            _instance._textOutputGameObjectOutBoundsContainer.SetActive(false);
        }
    }

    private void KeepTrackingBottom(TextMeshProUGUI textMeshPro)
    {
        if (textMeshPro.overflowMode == TextOverflowModes.Overflow)
        {
            RectTransform rectTransform = textMeshPro.rectTransform;
            float textHeight = rectTransform.rect.height;
            float contentHeight = textMeshPro.preferredHeight;

            if (contentHeight > textHeight)
            {
                float overflowAmount = contentHeight - textHeight;
                Vector3 currentPosition = rectTransform.localPosition;
                Vector3 targetPosition;
                targetPosition = new Vector3(currentPosition.x, overflowAmount, currentPosition.z);
                rectTransform.localPosition = targetPosition;
            }
            else
            {
                // Reset position if content height is smaller than text height
                rectTransform.localPosition = Vector3.zero;
            }
        }
    }
    
    static public void Log(string message)
    {
        Debug.Log(message);
        if (VRDebug._instance != null)
        {
            VRDebug._instance.DisplayLog(message, Color.green);
        }
    }
    
    static public void Log(float number)
    {
        VRDebug.Log(number.ToString());
    }
    
    static public void LogWarning(string message)
    {
        Debug.LogWarning(message);
        if (VRDebug._instance != null)
        {
            VRDebug._instance.DisplayLog(message, Color.red);
        }
    }
}